package sfio

import (
	"context"
	"database/sql"
	"fmt"
	"log/slog"

	"github.com/sfborg/sflib/ent/sfga"
	"github.com/sfborg/to-gn/internal/ent/sf"
	"github.com/sfborg/to-gn/pkg/config"
)

type sfio struct {
	cfg  config.Config
	arch sfga.Archive
	sdb  sfga.DB
	db   *sql.DB
}

func New(cfg config.Config, arch sfga.Archive, db sfga.DB) sf.SF {
	res := &sfio{
		cfg:  cfg,
		arch: arch,
		sdb:  db,
	}
	return res
}

func (s *sfio) Init() error {
	err := s.arch.Extract()
	if err != nil {
		return err
	}

	s.db, err = s.sdb.Connect()
	if err != nil {
		return err
	}

	ver := s.sdb.Version()
	if ver == "" || ver < s.cfg.MinVersionSFGA {
		err = fmt.Errorf("Incompatible SFGA schema version: '%s'", ver)
	}

	return nil
}

func (s *sfio) VersionSFGA() string {
	return s.sdb.Version()
}

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

func (s *sfio) GetNames(
	ctx context.Context,
	ch chan<- [][]string,
) error {

	// Postgres limits to 64k parameters, we need to adjust batch by the
	// number of fields in the table.
	// 11 because we insert into 11 fields in GN table.
	batchSize := s.cfg.BatchSize / 11
	q := `
    SELECT dwc_scientific_name_id, dwc_scientific_name
	    FROM core
	    GROUP BY dwc_scientific_name_id, dwc_scientific_name
	    ORDER BY dwc_scientific_name
	`
	rows, err := s.db.Query(q)
	if err != nil {
		slog.Error("Cannot run SFGA names query", "error", err)
		return err
	}
	defer rows.Close()

	batch := make([][]string, 0, batchSize)
	var count int
	var id, name string

	for rows.Next() {
		err = rows.Scan(&id, &name)
		if err != nil {
			slog.Error("Cannot read names row", "error", err)
			return err
		}
		if len(name) > 255 {
			continue
		}
		count++
		batch = append(batch, []string{id, name})
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
