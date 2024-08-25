package sf

import "context"

type SF interface {
	// Initializes SFGArchive and its database.
	Init() error

	// VersionSFGA returns the schema version of SFGArchive.
	VersionSFGA() string

	// GetVernNames adds vernacular name-strings.
	GetVernNames(context.Context, chan<- [][]string) error
}
