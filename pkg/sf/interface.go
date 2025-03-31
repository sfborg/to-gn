package sf

import (
	"context"

	"github.com/gnames/gnidump/pkg/ent/model"
	"golang.org/x/sync/errgroup"
)

// SF represents SFGA archive and export functions
type SF interface {
	// Initializes SFGArchive and its database.
	Init(sfgaPath string) error

	// VersionSFGA returns the schema version of SFGArchive.
	VersionSFGA() string

	// GetNames gets unique name-strings, parses them and creates
	// model for export to GNverifier.
	GetNames(
		g *errgroup.Group,
		ctx context.Context,
		chN chan<- []model.NameString,
		chC chan<- []model.Canonical,
		chCF chan<- []model.CanonicalFull,
		chCS chan<- []model.CanonicalStem,
	) error

	// GetNameIndices retrieves name string indices information
	// from SFGA archive.
	GetNameIndices(
		context.Context,
		chan<- []model.NameStringIndex,
	) error

	// GetVernNames gets unique vernacular name-strings.
	GetVernNames(context.Context, chan<- [][]string) error

	// GetVernIndices retrieves vernacular names indices information
	// from SFGA archive.
	GetVernIndices(
		context.Context,
		chan<- []model.VernacularStringIndex,
	) error

	// GetDataSource fetches data source information from SFGA
	GetDataSource(
		*model.DataSource,
	) error
}
