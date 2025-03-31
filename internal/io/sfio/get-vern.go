package sfio

import (
	"context"
	"log/slog"

	"github.com/gnames/gnidump/pkg/ent/model"
	"github.com/gnames/gnuuid"
)

// Postgres limits to 64k parameters, we need to adjust batch by the
// number of fields in the table.
// We are insertning whole batch in one query that contains not more than
// 64k fields.
var paramsLimit = 63_000 // 64k is the limit.

func (s *sfio) GetVernNames(
	ctx context.Context,
	ch chan<- [][]string,
) error {
	// we need to make sure that batch can fit the insert query
	batchSize := paramsLimit / 2
	q := `
    SELECT DISTINCT col__name FROM vernacular
	`
	rows, err := s.sfga.Db().Query(q)
	if err != nil {
		slog.Error("Cannot get SFGA vernacuar names query", "error", err)
		return err
	}
	defer rows.Close()

	batch := make([][]string, 0, batchSize)
	var count int

	for rows.Next() {
		var id, vern string
		count++
		err = rows.Scan(&vern)
		if err != nil {
			slog.Error("Cannot read vernacular row", "error", err)
			return err
		}
		id = gnuuid.New(vern).String()
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
	ctx context.Context,
	chIdx chan<- []model.VernacularStringIndex) error {
	batchSize := s.cfg.BatchSize

	q := `
    SELECT DISTINCT
     v.col__taxon_id, v.col__name, v.col__language,
	   v.col__area, v.col__country
    FROM vernacular v
	`
	rows, err := s.sfga.Db().Query(q)
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
		var name string
		err = rows.Scan(
			&vsi.RecordID, &name, &vsi.Language,
			&vsi.Locality, &vsi.CountryCode,
		)
		if err != nil {
			slog.Error("Cannot read vernacular string index row", "error", err)
			return err
		}
		vsi.VernacularStringID = gnuuid.New(name).String()
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
