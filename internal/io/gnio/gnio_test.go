package gnio_test

import (
	"context"
	"testing"
	"time"

	"github.com/sfborg/to-gn/internal/io/gnio"
	"github.com/sfborg/to-gn/pkg/config"
	"github.com/stretchr/testify/assert"
)

func TestNew(t *testing.T) {
	assert := assert.New(t)
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Millisecond)
	defer cancel()
	cfg := config.New()
	config.LoadEnv(&cfg)
	gn, err := gnio.New(cfg)
	assert.Nil(err)
	assert.NotNil(gn)
	assert.Nil(gn.CheckDb(ctx))

	cfg = config.New(config.OptDbHost("8.8.8.8"))
	gn, err = gnio.New(cfg)
	assert.NotNil(gn.CheckDb(ctx))
}
