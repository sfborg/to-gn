package togn

import (
	"errors"
	"log/slog"

	"github.com/sfborg/to-gn/pkg/config"
	"github.com/sfborg/to-gn/pkg/gn"
	"github.com/sfborg/to-gn/pkg/sf"
)

type togn struct {
	// cfg contains configuration data
	cfg config.Config
	// sf contains SFGA export functionality
	sf sf.SF
	// gn contains GNverifier importer
	gn gn.GN
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
	t.sf.Init(sfgaPath)

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
