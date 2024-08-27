package gn

import (
	"context"

	"github.com/gnames/gnidump/pkg/ent/model"
)

type GN interface {
	// Checks if there is a connection to the database.
	CheckDb(ctx context.Context) error

	// SetNames inserts unique name-strings to the database, ignoring
	// ones that are entered already.
	SetNames(ctx context.Context, ch <-chan []model.NameString) error

	// SetCanonicals inserts unique name-strings to the database, ignoring
	// ones that are entered already.
	SetCanonicals(ctx context.Context, ch <-chan []model.Canonical) error

	// SetCanonicalsFull inserts unique name-strings to the database, ignoring
	// ones that are entered already.
	SetCanonicalsFull(ctx context.Context, ch <-chan []model.CanonicalFull) error

	// SetCanonicalsStem inserts unique name-strings to the database, ignoring
	// ones that are entered already.
	SetCanonicalsStem(ctx context.Context, ch <-chan []model.CanonicalStem) error

	// SetVernNames inserts unique vernacular name-strings to the database,
	// ignoring ones that are entered already.
	SetVernNames(ctx context.Context, ch <-chan [][]string) error
}
