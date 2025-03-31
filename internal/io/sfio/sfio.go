package sfio

import (
	"fmt"

	"github.com/gnames/gnparser"
	"github.com/sfborg/sflib/pkg/sfga"
	"github.com/sfborg/to-gn/pkg/config"
	"github.com/sfborg/to-gn/pkg/ds"
	"github.com/sfborg/to-gn/pkg/sf"
)

type sfio struct {
	cfg     config.Config
	sfga    sfga.Archive
	ds      *ds.DataSourceInfo
	gnpPool chan gnparser.GNparser

	// hierarchy is used when core contains parent-child relationship to
	// represent a hierarchy.
	hierarchy map[string]*hNode
}

func New(cfg config.Config, arch sfga.Archive) sf.SF {
	res := &sfio{
		cfg:       cfg,
		sfga:      arch,
		gnpPool:   gnparser.NewPool(gnparser.NewConfig(), cfg.JobsNum),
		hierarchy: make(map[string]*hNode),
	}
	if ds, ok := ds.DataSourcesInfoMap[cfg.DataSourceID]; ok {
		res.ds = &ds
	}
	return res
}

func (s *sfio) Init(sfgaPath string) error {
	err := s.sfga.Fetch(sfgaPath, s.cfg.SfgaDir)
	if err != nil {
		return err
	}

	_, err = s.sfga.Connect()
	if err != nil {
		return err
	}

	ver := s.sfga.Version()
	if ver == "" || ver < s.cfg.MinVersionSFGA {
		err = fmt.Errorf("Incompatible SFGA schema version: '%s'", ver)
	}

	return nil
}

func (s *sfio) VersionSFGA() string {
	return s.sfga.Version()
}
