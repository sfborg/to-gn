package togn

// ToGN provies methods required to export SFGA archive to GNverifier
// database.
type ToGN interface {
	// Export reads SFGA data, transforms it and transfers to GN database.
	Export(sfgaPath string) error
}
