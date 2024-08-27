package gnio

import (
	"context"
	"fmt"
	"log/slog"
	"strings"
)

func (g *gnio) SetVernNames(
	ctx context.Context,
	ch <-chan [][]string,
) error {
	conn, err := g.db.Acquire(ctx)
	if err != nil {
		return err // Failed to get connection from pool
	}
	defer conn.Release()
	for v := range ch {
		select {
		case <-ctx.Done():
			slog.Info("Importing vernacuar name-strings got canceled.")
			return ctx.Err()
		default:
		}
		var vals []any
		valsQ := make([]string, len(v))
		count := 1
		for i := range v {
			id, name := v[i][0], v[i][1]
			vals = append(vals, id, name)
			valsQ[i] = fmt.Sprintf("($%d, $%d)", count, count+1)
			count += len(v[i])
		}

		q := fmt.Sprintf(`
			INSERT INTO vernacular_strings (id, name)
			VALUES %s
			ON CONFLICT DO NOTHING
			`,
			strings.Join(valsQ, ","),
		)
		_, err := conn.Exec(ctx, q, vals...)
		if err != nil {
			return err
		}
	}
	return nil
}
