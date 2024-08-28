package togn

import (
	"errors"
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
	if cfg.DataSourceID == 0 {
		err := errors.New("data source id cannot be 0")
		slog.Error("Please provide data-source ID", "error", err)
		return nil, err
	}
	res := togn{
		cfg: cfg,
		sf:  sf,
		gn:  gn,
	}
	return &res, nil
}

func (t *togn) Export(sfgaPath string) error {
	var err error
	slog.Info("Extracting SFGArchive")
	t.sf.Init()

	slog.Info("Exporting name strings")
	err = t.processNameStrings()
	if err != nil {
		return err
	}

	slog.Info("Exporting name string indices")
	err = t.processNameIndices()
	if err != nil {
		return err
	}

	slog.Info("Exporting vernacular name strings")
	err = t.processVernStrings()
	if err != nil {
		return err
	}

	slog.Info("Exporting vernacular names indices")
	err = t.processVernIndices()
	if err != nil {
		return err
	}

	slog.Info("Exporting data source information")
	err = t.processDataSources()
	if err != nil {
		return err
	}

	slog.Info("Export to GN database finished", "path", sfgaPath)
	return nil
}
