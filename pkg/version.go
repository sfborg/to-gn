package togn

import "github.com/gnames/gnlib/ent/gnvers"

var (
	// Version of the app. Hardcoded version appears only in release builds.
	Version = "v0.0.1"

	// Build timestamp
	Build string
)

func GetVersion() gnvers.Version {
	return gnvers.Version{
		Version: Version,
		Build:   Build,
	}
}
