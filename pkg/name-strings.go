package togn

import (
	"context"
	"log/slog"

	"golang.org/x/sync/errgroup"
)

func (t *togn) processNameStrings() error {
	var err error
	ch := make(chan [][]string)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	g, ctx := errgroup.WithContext(ctx)

	g.Go(func() error {
		err = t.sf.GetNames(ctx, ch)
		if err != nil {
			slog.Error("GetNames", "error", err)
		}
		return err
	})

	g.Go(func() error {
		err = t.gn.SetNames(ctx, ch)
		if err != nil {
			slog.Error("SetNames", "error", err)
		}
		return err
	})

	if err = g.Wait(); err != nil {
		slog.Error("Error in go routines", "error", err)
		return err
	}

	return nil
}
