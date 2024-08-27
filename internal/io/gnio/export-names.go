package gnio

import (
	"context"
	"fmt"
	"log/slog"
	"os"
	"strings"

	"github.com/gnames/gnidump/pkg/ent/model"
)

func (g *gnio) SetNames(
	ctx context.Context,
	ch <-chan []model.NameString,
) error {
	var recNum int
	conn, err := g.db.Acquire(ctx)
	if err != nil {
		return err // Failed to get connection from pool
	}
	defer conn.Release()
	fieldsNum := 11
	for n := range ch {
		// check for context errors
		select {
		case <-ctx.Done():
			slog.Info("Importing name-strings got canceled.")
			return ctx.Err()
		default:
		}

		var vals []any
		valsQ := make([]string, len(n))
		count := 1
		for i, v := range n {
			row := []any{v.ID, v.Name, v.Year, v.Cardinality, v.CanonicalID,
				v.CanonicalFullID, v.CanonicalStemID,
				v.Virus, v.Bacteria, v.Surrogate, v.ParseQuality,
			}
			vals = append(vals, row...)
			valsQ[i] = fmt.Sprintf(
				"($%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d, $%d)",
				count, count+1, count+2, count+3, count+4, count+5, count+6,
				count+7, count+8, count+9, count+10)
			count += fieldsNum
		}

		q := fmt.Sprintf(`
			INSERT INTO name_strings
			  (
			    id, name, year, cardinality,
			    canonical_id, canonical_full_id, canonical_stem_id,
					virus, bacteria, surrogate, parse_quality
			  )
			VALUES %s
			ON CONFLICT DO NOTHING
			`,
			strings.Join(valsQ, ","),
		)
		_, err := conn.Exec(ctx, q, vals...)
		if err != nil {
			return err
		}

		recNum += len(n)
		progressReport(recNum)
	}
	fmt.Fprintf(os.Stderr, "\r%s\r", strings.Repeat(" ", 80))
	return nil
}

func progressReport(recNum int) {
	str := fmt.Sprintf("Exported %00000d name-strings", recNum)
	fmt.Fprintf(os.Stderr, "\r%s", strings.Repeat(" ", 80))
	fmt.Fprintf(os.Stderr, "\r%s", str)
}
