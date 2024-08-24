package sf

type SF interface {
	// Initializes SFGA
	Init() error
	VersionSFGA() string
}
