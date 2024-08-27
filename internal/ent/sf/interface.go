package sf

import (
	"context"

	"github.com/gnames/gnidump/pkg/ent/model"
	"golang.org/x/sync/errgroup"
)

type SF interface {
	// Initializes SFGArchive and its database.
	Init() error

	// VersionSFGA returns the schema version of SFGArchive.
	VersionSFGA() string

	// GetNames gets unique name-strings
	GetNames(
		g *errgroup.Group,
		ctx context.Context,
		chN chan<- []model.NameString,
		chC chan<- []model.Canonical,
		chCF chan<- []model.CanonicalFull,
		chCS chan<- []model.CanonicalStem,
	) error

	// GetVernNames gets unique vernacular name-strings.
	GetVernNames(context.Context, chan<- [][]string) error

	// GetVernIndices retrieves vernacular names indices information
	// from SFGA archive.
	GetVernIndices(
		*errgroup.Group,
		context.Context,
		chan<- []model.VernacularStringIndex,
	) error
}
