package gn

import "context"

type GN interface {
	// Checks if there is a connection to the database.
	CheckDb(ctx context.Context) error

	// SetNames inserts unique name-strings to the database, ignoring
	// ones that are entered already.
	SetNames(ctx context.Context, ch <-chan [][]string) error

	// SetVernNames inserts unique vernacular name-strings to the database,
	// ignoring ones that are entered already.
	SetVernNames(ctx context.Context, ch <-chan [][]string) error
}
