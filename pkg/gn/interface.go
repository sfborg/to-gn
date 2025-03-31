package gn

import (
	"context"

	"github.com/gnames/gnidump/pkg/ent/model"
)

// GN interface provides methods required for importing SFGArchive data
// into GNverifier database.
type GN interface {
	// CheckDb verifies the database connection.
	CheckDb(ctx context.Context) error

	// SetNames inserts unique name-strings, skipping duplicates.
	SetNames(ctx context.Context, ch <-chan []model.NameString) error

	// SetCanonicals inserts unique canonical name-strings, skipping duplicates.
	SetCanonicals(ctx context.Context, ch <-chan []model.Canonical) error

	// SetCanonicalsFull inserts unique full canonical name-strings, skipping
	// duplicates.
	SetCanonicalsFull(
		ctx context.Context,
		ch <-chan []model.CanonicalFull,
	) error

	// SetCanonicalsStem inserts unique stemmed canonical name-strings, skipping
	// duplicates.
	SetCanonicalsStem(ctx context.Context, ch <-chan []model.CanonicalStem) error

	// SetNameIndices exports name-string index data to GN.
	SetNameIndices(ctx context.Context, ch <-chan []model.NameStringIndex) error

	// SetVernNames inserts unique vernacular name-strings, skipping duplicates.
	SetVernNames(ctx context.Context, ch <-chan [][]string) error

	// SetVernIndices exports vernacular string index data to GN.
	SetVernIndices(
		ctx context.Context,
		ch <-chan []model.VernacularStringIndex,
	) error

	// SetDataSource creates/updates the data-source record in the GN database.
	SetDataSource(
		ds model.DataSource,
	) error

	// NameNum finds number of name indices and updates internal data.
	NamesNum(context.Context, *model.DataSource) error

	// VernNum finds number of vernacular indices and updates internal data.
	VernNum(context.Context, *model.DataSource) error
}
