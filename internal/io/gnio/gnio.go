package gnio

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/sfborg/to-gn/internal/ent/gn"
	"github.com/sfborg/to-gn/pkg/config"
)

type gnio struct {
	cfg config.Config
	db  *pgxpool.Pool
}

func New(cfg config.Config) (gn.GN, error) {
	res := gnio{
		cfg: cfg,
	}

	db, err := newDB(cfg)
	if err != nil {
		return nil, err
	}

	res.db = db
	return &res, nil
}

func (g *gnio) CheckDb(ctx context.Context) error {
	conn, err := g.db.Acquire(ctx)
	if err != nil {
		return err // Failed to get connection from pool
	}
	defer conn.Release()

	err = conn.Ping(ctx)
	if err != nil {
		return err // Ping failed, likely no connection
	}
	return nil // Connection successful
}
