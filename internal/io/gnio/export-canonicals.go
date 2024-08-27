package gnio

import (
	"context"
	"fmt"
	"log/slog"
	"strings"

	"github.com/gnames/gnidump/pkg/ent/model"
	"github.com/jackc/pgx/v5/pgxpool"
)

// Specific implementations using the generic function
func (g *gnio) SetCanonicals(
	ctx context.Context,
	ch <-chan []model.Canonical,
) error {
	return setCanonicals(ctx, g.db, ch, "canonicals")
}

func (g *gnio) SetCanonicalsFull(
	ctx context.Context,
	ch <-chan []model.CanonicalFull,
) error {
	return setCanonicals(ctx, g.db, ch, "canonical_fulls")
}

func (g *gnio) SetCanonicalsStem(
	ctx context.Context,
	ch <-chan []model.CanonicalStem,
) error {
	return setCanonicals(ctx, g.db, ch, "canonical_stems")
}

// Generic function to handle insertions for different canonical types
func setCanonicals[T model.NameID](
	ctx context.Context,
	db *pgxpool.Pool,
	ch <-chan []T,
	table string,
) error {
	conn, err := db.Acquire(ctx)
	if err != nil {
		return err // Failed to get connection from pool
	}
	defer conn.Release()

	for cs := range ch {
		select {
		case <-ctx.Done():
			slog.Info("Importing got canceled.", "table", table)
			return ctx.Err()
		default:
		}

		var vals []any
		valsQ := make([]string, len(cs))
		count := 1
		for i := range cs {
			id, name := cs[i].StringID(), cs[i].StringName()
			vals = append(vals, id, name)
			valsQ[i] = fmt.Sprintf("($%d, $%d)", count, count+1)
			count += 2
		}

		q := fmt.Sprintf(`
		          INSERT INTO %s (id, name)
		          VALUES %s
		          ON CONFLICT DO NOTHING
		          `,
			table,
			strings.Join(valsQ, ","),
		)
		_, err := conn.Exec(ctx, q, vals...)
		if err != nil {
			return err
		}
	}
	return nil
}
