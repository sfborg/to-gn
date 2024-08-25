package gnio

import (
	"context"
	"fmt"
	"strconv"
	"strings"

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

// InsertRows inserts a batch of rows into a table.
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

// getBulkInsertSQL is a helper function to prepare a SQL query for a bulk insert.
//
// For example:
//
// SQLString = "INSERT INTO notes (thing_a, thing_b) VALUES %s"
// rowValueSQL  = "?, ?"
// numRows = 3
//
// Would be transformed into:
//
// INSERT INTO notes (thing_a, thing_b)
// VALUES
//
//	($1, $2),
//	($3, $4),
//	($5, $6)
//
// Also see:
// https://stackoverflow.com/questions/12486436/how-do-i-batch-sql-statements-with-package-database-sql
func getBulkInsertSQL(SQLString string, rowValueSQL string, numRows int) string {
	// Combine the base SQL string and N value strings
	valueStrings := make([]string, 0, numRows)
	for i := 0; i < numRows; i++ {
		valueStrings = append(valueStrings, "("+rowValueSQL+")")
	}
	allValuesString := strings.Join(valueStrings, ",")
	SQLString = fmt.Sprintf(SQLString, allValuesString)

	// Convert all of the "?" to "$1", "$2", "$3", etc.
	// (which is the way that pgx expects query variables to be)
	numArgs := strings.Count(SQLString, "?")
	SQLString = strings.ReplaceAll(SQLString, "?", "$%v")
	numbers := make([]interface{}, 0, numRows)
	for i := 1; i <= numArgs; i++ {
		numbers = append(numbers, strconv.Itoa(i))
	}
	return fmt.Sprintf(SQLString, numbers...)
}

// getBulkInsertSQLSimple is a helper function to prepare a SQL query for a bulk insert.
// getBulkInsertSQLSimple is used over getBulkInsertSQL when all of the values are plain question
// marks (e.g. a 1-for-1 value insertion).
// The example given for getBulkInsertSQL is such a query.
func getBulkInsertSQLSimple(SQLString string, numArgsPerRow int, numRows int) string {
	questionMarks := make([]string, 0, numArgsPerRow)
	for i := 0; i < numArgsPerRow; i++ {
		questionMarks = append(questionMarks, "?")
	}
	rowValueSQL := strings.Join(questionMarks, ", ")
	return getBulkInsertSQL(SQLString, rowValueSQL, numRows)
}
