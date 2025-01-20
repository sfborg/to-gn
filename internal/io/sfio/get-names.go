package sfio

import (
	"context"
	"database/sql"
	"log/slog"
	"strconv"
	"strings"
	"sync"

	"github.com/gnames/gnidump/pkg/ent/model"
	"github.com/gnames/gnparser/ent/parsed"
	"github.com/gnames/gnuuid"
	"golang.org/x/sync/errgroup"
)

func (s *sfio) GetNames(
	g *errgroup.Group,
	ctx context.Context,
	chN chan<- []model.NameString,
	chC chan<- []model.Canonical,
	chCF chan<- []model.CanonicalFull,
	chCS chan<- []model.CanonicalStem,
) error {
	chIn := make(chan string)
	var wg sync.WaitGroup

	// temporary table caches scientific name parsing results
	err := s.setTempParserTable()
	if err != nil {
		return err
	}

	for i := 0; i < s.cfg.JobsNum; i++ {
		wg.Add(1)
		g.Go(func() error {
			defer wg.Done()
			return s.nameParserWorker(ctx, chIn, chN, chC, chCF, chCS)
		})
	}

	err = s.loadNames(ctx, chIn)
	close(chIn)
	if err != nil {
		return err
	}

	wg.Wait()
	return nil
}

func (s *sfio) loadNames(ctx context.Context, chIn chan<- string) error {
	q := `
    SELECT distinct gn_scientific_name_string
	    FROM name
	    ORDER BY gn_scientific_name_string
	`
	rows, err := s.db.Query(q)
	if err != nil {
		slog.Error("Cannot run SFGA names query", "error", err)
		return err
	}
	defer rows.Close()

	var name string
	var count int
	for rows.Next() {
		// Check for context cancellation periodically
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}
		count++
		err = rows.Scan(&name)
		if err != nil {
			slog.Error("Cannot read names row", "error", err)
			return err
		}

		chIn <- name

	}
	return nil
}

func (s *sfio) nameParserWorker(
	ctx context.Context,
	chIn <-chan string,
	chN chan<- []model.NameString,
	chC chan<- []model.Canonical,
	chCF chan<- []model.CanonicalFull,
	chCS chan<- []model.CanonicalStem,
) error {
	gnp := <-s.gnpPool
	defer func() {
		s.gnpPool <- gnp
	}()

	batchNames := s.cfg.BatchSize / 11
	batchCanonical := s.cfg.BatchSize / 2
	var countN, countC int

	var nameM model.NameString
	var canM model.Canonical
	var canFullM model.CanonicalFull
	var canStemM model.CanonicalStem

	var batchN []model.NameString
	var batchC []model.Canonical
	var batchCF []model.CanonicalFull
	var batchCS []model.CanonicalStem

	for n := range chIn {
		countN++
		// Check for context cancellation periodically
		select {
		case <-ctx.Done():
			slog.Error("nameParserWorker received context error")
			return ctx.Err()
		default:
		}

		pd := gnp.ParseName(n)

		var bacteria bool
		if pd.Bacteria != nil && pd.Bacteria.String() == "yes" {
			bacteria = true
		}
		var surrogate bool
		if pd.Surrogate != nil {
			surrogate = true
		}

		nameM = model.NameString{
			ID:           pd.VerbatimID,
			Name:         pd.Verbatim,
			Virus:        pd.Virus,
			Bacteria:     bacteria,
			Surrogate:    surrogate,
			ParseQuality: pd.ParseQuality,
		}

		if pd.Parsed {
			year := parseYear(pd)
			cardinality := sql.NullInt32{
				Int32: int32(pd.Cardinality),
				Valid: true,
			}
			canID := sql.NullString{
				String: gnuuid.New(pd.Canonical.Simple).String(),
				Valid:  true,
			}
			canFullID := sql.NullString{
				String: gnuuid.New(pd.Canonical.Full).String(),
				Valid:  true,
			}
			canStemID := sql.NullString{
				String: gnuuid.New(pd.Canonical.Stemmed).String(),
				Valid:  true,
			}
			nameM.Year = year
			nameM.Cardinality = cardinality
			nameM.CanonicalID = canID
			nameM.CanonicalFullID = canFullID
			nameM.CanonicalStemID = canStemID

			canM = model.Canonical{
				ID:   canID.String,
				Name: pd.Canonical.Simple,
			}

			canFullM = model.CanonicalFull{
				ID:   canFullID.String,
				Name: pd.Canonical.Full,
			}

			canStemM = model.CanonicalStem{
				ID:   canStemID.String,
				Name: pd.Canonical.Stemmed,
			}
		}

		batchN = append(batchN, nameM)

		if countN%batchNames == 0 {
			countN = 0
			chN <- batchN
			batchN = batchN[:0]
		}

		if !pd.Parsed {
			continue
		}

		// process canonicals
		countC++

		batchC = append(batchC, canM)
		batchCS = append(batchCS, canStemM)

		if canM.ID != canFullM.ID {
			batchCF = append(batchCF, canFullM)
		}

		if countC%batchCanonical == 0 {
			countC = 0
			if len(batchC) > 0 {
				chC <- batchC
			}
			if len(batchCF) > 0 {
				chCF <- batchCF
			}
			if len(batchCS) > 0 {
				chCS <- batchCS
			}
			batchC = batchC[:0]
			batchCF = batchCF[:0]
			batchCS = batchCS[:0]
		}

	}
	// add leftovers
	if len(batchN) > 0 {
		chN <- batchN
	}
	if len(batchC) > 0 {
		chC <- batchC
	}
	if len(batchCF) > 0 {
		chCF <- batchCF
	}
	if len(batchCS) > 0 {
		chCS <- batchCS
	}

	return nil
}

func parseYear(p parsed.Parsed) sql.NullInt16 {
	res := sql.NullInt16{}
	if p.Authorship == nil || p.Authorship.Year == "" {
		return res
	}
	yr := strings.Trim(p.Authorship.Year, "()")
	yrInt, err := strconv.Atoi(yr[0:4])
	if err != nil {
		return res
	}
	return sql.NullInt16{Int16: int16(yrInt), Valid: true}
}

func (s *sfio) setTempParserTable() error {
	q := `
CREATE TEMPORARY TABLE parsed_temp (
  gn_scientific_name_string string PRIMARY KEY,
	id string NOT NULL,
  canonical TEXT DEFAULT '',
  canonical_full TEXT DEFAULT ''
)
`
	_, err := s.db.Exec(q)
	if err != nil {
		slog.Error("Cannot create parsed_temp table", "error", err)
		return err
	}
	return nil
}
