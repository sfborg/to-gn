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

	for i := 0; i < s.cfg.JobsNum; i++ {
		wg.Add(1)
		g.Go(func() error {
			defer wg.Done()
			return s.nameParserWorker(ctx, chIn, chN, chC, chCF, chCS)
		})
	}

	g.Go(func() error {
		return s.loadNames(ctx, chIn)
	})

	// close chOut when all workers are done
	go func() {
		wg.Wait()
		close(chN)
		close(chC)
		close(chCF)
		close(chCS)
	}()

	return nil
}

func (s *sfio) GetNameIndices(
	ctx context.Context,
	chIdx chan<- []model.NameStringIndex) error {
	batchSize := 50_000

	q := `
    SELECT DISTINCT
			dwc_taxon_id, dwc_scientific_name_id,
	    dwc_taxon_rank, dwc_accepted_name_usage_id,  
	    dwc_higher_classification, higher_classification_ids,
	    higher_classification_ranks
    FROM core
	`
	rows, err := s.db.Query(q)
	if err != nil {
		slog.Error("Cannot get SFGA name string indices query", "error", err)
		return err
	}
	defer rows.Close()

	batch := make([]model.NameStringIndex, 0, batchSize)
	var count int

	for rows.Next() {
		nsi := model.NameStringIndex{DataSourceID: s.cfg.DataSourceID}
		count++
		err = rows.Scan(
			&nsi.RecordID, &nsi.NameStringID,
			&nsi.Rank, &nsi.AcceptedRecordID,
			&nsi.Classification, &nsi.ClassificationIDs,
			&nsi.ClassificationRanks,
		)
		if err != nil {
			slog.Error("Cannot read name string index row", "error", err)
			return err
		}
		batch = append(batch, nsi)
		if count == batchSize {
			count = 0
			chIdx <- batch
			batch = batch[:0]
		}
		// Check for context cancellation periodically
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}
	}
	if len(batch) > 0 {
		chIdx <- batch
	}
	close(chIdx)
	return nil
}

func (s *sfio) loadNames(ctx context.Context, chIn chan<- string) error {
	q := `
    SELECT distinct dwc_scientific_name
	    FROM core
	    ORDER BY dwc_scientific_name
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
	close(chIn)
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
