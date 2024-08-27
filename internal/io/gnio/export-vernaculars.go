package gnio

import (
	"context"
	"fmt"
	"log/slog"
	"strings"

	"github.com/gnames/gnidump/pkg/ent/model"
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

func (g *gnio) SetVernIndices(
	ctx context.Context,
	chIdx <-chan []model.VernacularStringIndex,
) error {
	var err error

	err = g.cleanOldData(ctx)
	if err != nil {
		return err
	}

	columns := []string{
		"data_source_id", "record_id", "vernacular_string_id",
		"language", "lang_code", "locality", "country_code",
	}
	for vsi := range chIdx {
		rows := make([][]any, 0, len(vsi))
		for i := range vsi {
			row := []any{
				g.cfg.DataSourceID, vsi[i].RecordID, vsi[i].VernacularStringID,
				vsi[i].Language, vsi[i].LangCode, vsi[i].Locality,
				vsi[i].CountryCode}

			rows = append(rows, row)
		}

		_, err := insertRows(g.db, "vernacular_string_indices", columns, rows)
		if err != nil {
			slog.Error(
				"Cannot insert rows to vernacular_string_indices table",
				"error", err,
			)
			for range chIdx {
			}
			return err
		}
		select {
		case <-ctx.Done():
			return ctx.Err()
		default:
		}
	}
	return nil
}

func (g *gnio) cleanOldData(ctx context.Context) error {
	conn, err := g.db.Acquire(ctx)
	if err != nil {
		return err // Failed to get connection from pool
	}
	defer conn.Release()
	q := `DELETE FROM vernacular_string_indices WHERE data_source_id = $1`
	_, err = conn.Exec(ctx, q, g.cfg.DataSourceID)
	if err != nil {
		return err
	}
	return nil
}
