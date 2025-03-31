package sfio_test

import (
	"testing"

	"github.com/sfborg/sflib"
	"github.com/sfborg/to-gn/internal/io"
	"github.com/sfborg/to-gn/internal/io/sfio"
	"github.com/sfborg/to-gn/pkg/config"
	"github.com/stretchr/testify/assert"
)

func TestInit(t *testing.T) {
	assert := assert.New(t)

	cfg := config.New()
	config.LoadEnv(&cfg)

	err := io.ResetCache(cfg)
	assert.Nil(err)
	sfga := sflib.NewSfga()

	sfgaPath := "../../../testdata/182-gymno.sql"
	sf := sfio.New(cfg, sfga)
	err = sf.Init(sfgaPath)
	assert.Nil(err)

	ver := sf.VersionSFGA()
	assert.True(len(ver) > 5)
}
