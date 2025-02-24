package sfio

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"strings"
	"sync"

	"github.com/dustin/go-humanize"
	"github.com/gnames/coldp/ent/coldp"
	"github.com/gnames/gnparser"
	"golang.org/x/sync/errgroup"
)

type hNode struct {
	id              string
	parentID        string
	taxonomicStatus coldp.TaxonomicStatus
	name            string
	rank            string
}

var badNodes = make(map[string]struct{})

func (s *sfio) buildHierarchy() error {
	chIn := make(chan coldp.NameUsage)
	chOut := make(chan *hNode)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	g, ctx := errgroup.WithContext(ctx)
	var wg sync.WaitGroup

	for i := 0; i < s.cfg.JobsNum; i++ {
		wg.Add(1)
		g.Go(func() error {
			defer wg.Done()
			return s.hierarchyWorker(ctx, chIn, chOut)
		})
	}

	g.Go(func() error {
		return s.createHierarchy(ctx, chOut)
	})

	// close chOut when all workers are done
	go func() {
		wg.Wait()
		close(chOut)
	}()

	err := s.loadNameUsage(ctx, chIn)
	if err != nil {
		return err
	}
	close(chIn)

	if err := g.Wait(); err != nil {
		return err
	}
	return nil
}

func (s *sfio) hierarchyWorker(
	ctx context.Context,
	chIn <-chan coldp.NameUsage,
	chOut chan<- *hNode,
) error {
	p := <-s.gnpPool
	defer func() {
		s.gnpPool <- p
	}()

	for v := range chIn {
		row, err := s.processHierarchyRow(p, v)
		if err != nil {
			for range chIn {
			}
			return err
		}

		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
			chOut <- row
		}
	}

	return nil
}

func (s *sfio) processHierarchyRow(p gnparser.GNparser, v coldp.NameUsage) (*hNode, error) {
	parsed := p.ParseName(v.ScientificName)
	var name string
	if parsed.Parsed {
		name = parsed.Canonical.Simple
	}

	parentID := v.ParentID
	if parentID == v.ID {
		parentID = ""
	}

	rank := strings.ToLower(v.Rank.String())

	res := &hNode{
		id:              v.ID,
		rank:            rank,
		name:            name,
		parentID:        v.ParentID,
		taxonomicStatus: v.TaxonomicStatus,
	}

	return res, nil
}

func (s *sfio) createHierarchy(ctx context.Context, chOut <-chan *hNode) error {
	var count int
	for v := range chOut {
		if v.id == "" {
			continue
		}
		count++
		if count%100_000 == 0 {
			progressReport(count, "hierarchy records")
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
			s.hierarchy[v.id] = v
		}
	}
	return nil
}

func (s *sfio) getBreadcrumbs(id string) (bcTx, bcRnk, bcIdx string) {
	nodes := s.breadcrumbsNodes(id)

	ts := make([]string, len(nodes))
	rs := make([]string, len(nodes))
	is := make([]string, len(nodes))

	for i := range nodes {
		ts[i] = nodes[i].name
		rs[i] = nodes[i].rank
		is[i] = nodes[i].id
	}

	return strings.Join(ts, "|"), strings.Join(rs, "|"), strings.Join(is, "|")
}

func (s *sfio) breadcrumbsNodes(id string) []*hNode {
	id = strings.TrimSpace(id)
	var res []*hNode
	var node *hNode
	var ok bool
	var currID string

	currID = id
	for {
		// parentID exists, but node with such ID does not
		if node, ok = s.hierarchy[currID]; !ok {
			if _, ok = badNodes[currID]; !ok {
				badNodes[currID] = struct{}{}
				fmt.Fprintf(os.Stderr, "\r%s\r", strings.Repeat(" ", 80))
				slog.Warn("Hierarchy node not found, making short breadcrumbs", "id", currID)
			}
			return res
		}

		res = append([]*hNode{node}, res...)

		// set a trigger to get out
		if node.parentID == "" {
			return res
		}
		currID = node.parentID
	}
}

func (s *sfio) loadNameUsage(
	ctx context.Context,
	chIn chan<- coldp.NameUsage,
) error {
	q := `
SELECT t.id, t.parent_id, t.status_id, n.scientific_name, n.rank_id 
	FROM taxon t join name n on n.id = t.name_id
`
	rows, err := s.db.Query(q)
	if err != nil {
		slog.Error("Cannot run SFGA hierarchy query", "error", err)
		return err
	}
	defer rows.Close()

	for rows.Next() {
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}

		var nu coldp.NameUsage
		var rank, status string

		err = rows.Scan(
			&nu.ID, &nu.ParentID, &status,
			&nu.ScientificName, &rank,
		)
		if err != nil {
			slog.Error("Cannot read hierarchy row", "error", err)
			return err
		}
		nu.TaxonomicStatus = coldp.AcceptedTS
		if status != "" {
			nu.TaxonomicStatus = coldp.NewTaxonomicStatus(status)
		}
		nu.Rank = coldp.NewRank(rank)
		chIn <- nu
	}

	return nil
}

func progressReport(recNum int, ent string) {
	str := fmt.Sprintf("Processed %s %s", humanize.Comma(int64(recNum)), ent)
	fmt.Fprintf(os.Stderr, "\r%s", strings.Repeat(" ", 80))
	fmt.Fprintf(os.Stderr, "\r%s", str)
}
