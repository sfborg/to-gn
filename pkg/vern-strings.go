package togn

import (
	"context"
	"log/slog"

	"github.com/gnames/gnidump/pkg/ent/model"
	"golang.org/x/sync/errgroup"
)

func (t *togn) processVernStrings() error {
	var err error
	ch := make(chan [][]string)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	g, ctx := errgroup.WithContext(ctx)

	g.Go(func() error {
		err = t.sf.GetVernNames(ctx, ch)
		if err != nil {
			slog.Error("GetVernNames", "error", err)
		}
		return err
	})

	g.Go(func() error {
		err = t.gn.SetVernNames(ctx, ch)
		if err != nil {
			slog.Error("SetVernNames", "error", err)
		}
		return err
	})

	if err = g.Wait(); err != nil {
		slog.Error("Error in go routines", "error", err)
		return err
	}

	return nil
}

func (t *togn) processVernIndices() error {
	var err error
	chIdx := make(chan []model.VernacularStringIndex)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	g, ctx := errgroup.WithContext(ctx)

	g.Go(func() error {
		err = t.sf.GetVernIndices(ctx, chIdx)
		if err != nil {
			slog.Error("GetVernIndices", "error", err)
		}
		return err
	})

	g.Go(func() error {
		err = t.gn.SetVernIndices(ctx, chIdx)
		if err != nil {
			slog.Error("SetVernIndices", "error", err)
		}
		return err
	})

	if err = g.Wait(); err != nil {
		slog.Error("Error in go routines", "error", err)
		return err
	}

	return nil
}
