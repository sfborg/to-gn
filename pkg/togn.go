package togn

import (
	"log/slog"

	"github.com/sfborg/to-gn/internal/ent/gn"
	"github.com/sfborg/to-gn/internal/ent/sf"
	"github.com/sfborg/to-gn/pkg/config"
)

type togn struct {
	cfg config.Config
	sf  sf.SF
	gn  gn.GN
}

func New(cfg config.Config, sf sf.SF, gn gn.GN) (ToGN, error) {
	res := togn{
		cfg: cfg,
		sf:  sf,
		gn:  gn,
	}
	return &res, nil
}

func (t *togn) Export(sfgaPath string) error {
	slog.Info("Extracting SFGArchive")
	t.sf.Init()
	slog.Info("Import to GN database finished", "path", sfgaPath)
	return nil
}
