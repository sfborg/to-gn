package sfio

import (
	"database/sql"
	"fmt"

	"github.com/gnames/gnparser"
	"github.com/sfborg/sflib/ent/sfga"
	"github.com/sfborg/to-gn/internal/ent/ds"
	"github.com/sfborg/to-gn/internal/ent/sf"
	"github.com/sfborg/to-gn/pkg/config"
)

type sfio struct {
	cfg     config.Config
	arch    sfga.Archive
	sdb     sfga.DB
	db      *sql.DB
	ds      *ds.DataSourceInfo
	gnpPool chan gnparser.GNparser
}

func New(cfg config.Config, arch sfga.Archive, db sfga.DB) sf.SF {
	res := &sfio{
		cfg:     cfg,
		arch:    arch,
		sdb:     db,
		gnpPool: gnparser.NewPool(gnparser.NewConfig(), cfg.JobsNum),
	}
	if ds, ok := ds.DataSourcesInfoMap[cfg.DataSourceID]; ok {
		res.ds = &ds
	}
	return res
}

func (s *sfio) Init() error {
	err := s.arch.Extract()
	if err != nil {
		return err
	}

	s.db, err = s.sdb.Connect()
	if err != nil {
		return err
	}

	ver := s.sdb.Version()
	if ver == "" || ver < s.cfg.MinVersionSFGA {
		err = fmt.Errorf("Incompatible SFGA schema version: '%s'", ver)
	}

	return nil
}

func (s *sfio) VersionSFGA() string {
	return s.sdb.Version()
}
