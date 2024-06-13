package togn

import (
	"log/slog"

	"github.com/sfga/to-gn/pkg/config"
)

type togn struct {
	cfg config.Config
}

func New(cfg config.Config) (ToGN, error) {
	res := togn{
		cfg: cfg,
	}
	return &res, nil
}

func (t *togn) Import(sfgaPath string) error {
	slog.Info("Import to GN database finished", "path", sfgaPath)
	return nil
}
