package sfio

import (
	"context"
	"log/slog"

	"github.com/gnames/gnidump/pkg/ent/model"
	"golang.org/x/sync/errgroup"
)

func (s *sfio) GetVernNames(
	ctx context.Context,
	ch chan<- [][]string,
) error {

	// Postgres limits to 64k parameters, we need to adjust batch by the
	// number of fields in the table.
	batchSize := s.cfg.BatchSize / 2
	q := `
    SELECT DISTINCT
     vernacular_name_id, dwc_vernacular_name
    FROM vernaculars
	`
	rows, err := s.db.Query(q)
	if err != nil {
		slog.Error("Cannot get SFGA vernacuar names query", "error", err)
		return err
	}
	defer rows.Close()

	batch := make([][]string, 0, batchSize)
	var count int
	var id, vern string

	for rows.Next() {
		count++
		err = rows.Scan(&id, &vern)
		if err != nil {
			slog.Error("Cannot read vernacular row", "error", err)
			return err
		}
		batch = append(batch, []string{id, vern})
		if count == batchSize {
			count = 0
			ch <- batch
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
		ch <- batch
	}
	close(ch)
	return nil
}

func (s *sfio) GetVernIndices(
	g *errgroup.Group,
	ctx context.Context,
	chIdx chan<- []model.VernacularStringIndex) error {
	batchSize := s.cfg.BatchSize / 8

	q := `
    SELECT DISTINCT
     dwc_taxon_id, vernacular_name_id, dcterms_language,
	   lang_code, dwc_locality, dwc_country_code 
    FROM vernaculars
	`
	rows, err := s.db.Query(q)
	if err != nil {
		slog.Error("Cannot get SFGA vernacuar name indices query", "error", err)
		return err
	}
	defer rows.Close()

	batch := make([]model.VernacularStringIndex, 0, batchSize)
	var count int

	for rows.Next() {
		vsi := model.VernacularStringIndex{DataSourceID: s.cfg.DataSourceID}
		count++
		err = rows.Scan(
			&vsi.RecordID, &vsi.VernacularStringID, &vsi.Language,
			&vsi.LangCode, &vsi.Locality, &vsi.CountryCode,
		)
		if err != nil {
			slog.Error("Cannot read vernacular string index row", "error", err)
			return err
		}
		batch = append(batch, vsi)
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
