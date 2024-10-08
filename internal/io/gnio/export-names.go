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
		progressReport(recNum, "name-strings")
	}
	fmt.Fprintf(os.Stderr, "\r%s\r", strings.Repeat(" ", 80))
	return nil
}

func (g *gnio) SetNameIndices(
	ctx context.Context,
	chIdx <-chan []model.NameStringIndex,
) error {
	var err error

	err = g.cleanNSIData(ctx)
	if err != nil {
		return err
	}

	var recNum int
	columns := []string{
		"data_source_id", "record_id", "local_id", "global_id", "name_string_id",
		"outlink_id", "code_id", "rank", "accepted_record_id",
		"classification", "classification_ids", "classification_ranks",
	}
	for nsi := range chIdx {
		recNum += len(nsi)
		rows := make([][]any, 0, len(nsi))
		// TODO get real nomeclatural code_id
		for i := range nsi {
			acceptedID := nsi[i].AcceptedRecordID
			if strings.TrimSpace(acceptedID) == "" {
				acceptedID = nsi[i].RecordID
			}

			row := []any{
				g.cfg.DataSourceID, nsi[i].RecordID, nsi[i].LocalID,
				nsi[i].GlobalID, nsi[i].NameStringID, nsi[i].OutlinkID,
				nsi[i].CodeID, nsi[i].Rank, acceptedID,
				nsi[i].Classification, nsi[i].ClassificationIDs,
				nsi[i].ClassificationRanks,
			}

			rows = append(rows, row)
		}

		_, err := insertRows(g.db, "name_string_indices", columns, rows)
		if err != nil {
			slog.Error(
				"Cannot insert rows to name_string_indices table",
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
		progressReport(recNum, "name-string indices")
	}
	fmt.Fprintf(os.Stderr, "\r%s\r", strings.Repeat(" ", 80))
	slog.Info("Finished exporting name indices", "names-num", recNum)
	return nil
}

// cleanNSIData removes old name string indices data for the
// given data-source.
func (g *gnio) cleanNSIData(ctx context.Context) error {
	conn, err := g.db.Acquire(ctx)
	if err != nil {
		return err // Failed to get connection from pool
	}
	defer conn.Release()
	q := `DELETE FROM name_string_indices WHERE data_source_id = $1`
	_, err = conn.Exec(ctx, q, g.cfg.DataSourceID)
	if err != nil {
		return err
	}
	return nil
}

func progressReport(recNum int, ent string) {
	str := fmt.Sprintf("Exported %d %s", recNum, ent)
	fmt.Fprintf(os.Stderr, "\r%s", strings.Repeat(" ", 80))
	fmt.Fprintf(os.Stderr, "\r%s", str)
}
