package gnio

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/sfborg/to-gn/pkg/config"
)

func dburl(cfg config.Config) string {
	return fmt.Sprintf("postgres://%s:%s@%s:%d/%s?sslmode=disable",
		cfg.DbUser, cfg.DbPass, cfg.DbHost, 5432, cfg.DbDatabase)
}

// newDB creates a new connections pool to the database.
func newDB(cfg config.Config) (*pgxpool.Pool, error) {
	pool, err := pgxpool.New(
		context.Background(),
		dburl(cfg),
	)
	if err != nil {
		return nil, err
	}

	return pool, nil
}

// insertRows inserts a batch of rows into a table.
func insertRows(
	d *pgxpool.Pool,
	tbl string,
	columns []string,
	rows [][]any,
) (int64, error) {
	copyCount, err := d.CopyFrom(
		context.Background(),
		pgx.Identifier{tbl},
		columns,
		pgx.CopyFromRows(rows),
	)
	return int64(copyCount), err
}
