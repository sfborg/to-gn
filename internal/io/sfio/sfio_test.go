package sfio_test

import (
	"testing"

	"github.com/sfborg/sflib/io/archio"
	"github.com/sfborg/sflib/io/dbio"
	"github.com/sfborg/to-gn/internal/io/sfio"
	"github.com/sfborg/to-gn/pkg/config"
	"github.com/stretchr/testify/assert"
)

func TestInit(t *testing.T) {
	assert := assert.New(t)

	cfg := config.New()
	db := dbio.New(cfg.CacheDbDir)

	sfgaPath := "../../../testdata/dinof.sql"
	a, err := archio.New(sfgaPath, cfg.CacheDir)
	assert.Nil(err)
	sf := sfio.New(cfg, a, db)
	err = sf.Init()
	assert.Nil(err)

	ver := sf.VersionSFGA()
	assert.True(len(ver) > 5)
}
