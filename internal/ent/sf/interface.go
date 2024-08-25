package sf

import "context"

type SF interface {
	// Initializes SFGArchive and its database.
	Init() error

	// VersionSFGA returns the schema version of SFGArchive.
	VersionSFGA() string

	// GetNames gets unique name-strings
	GetNames(context.Context, chan<- [][]string) error

	// GetVernNames  gets unique vernacular name-strings.
	GetVernNames(context.Context, chan<- [][]string) error
}
