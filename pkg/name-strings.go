package togn

import (
	"context"
	"log/slog"

	"github.com/gnames/gnidump/pkg/ent/model"
	"golang.org/x/sync/errgroup"
)

func (t *togn) processNameStrings() error {
	var err error
	//channel for name-strings
	chN := make(chan []model.NameString)
	// channel for canonicals
	chC := make(chan []model.Canonical)
	// channel for full canonicals
	chCF := make(chan []model.CanonicalFull)
	// channel for stemmed canonicals
	chCS := make(chan []model.CanonicalStem)
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	g, ctx := errgroup.WithContext(ctx)

	// Takes names from SFGA archive, processes them and
	// puts them into name-string and canonical channels.
	g.Go(func() error {
		err = t.sf.GetNames(g, ctx, chN, chC, chCF, chCS)
		if err != nil {
			slog.Error("GetNames", "error", err)
		}
		return err
	})

	// Exports name-strings to GN database.
	g.Go(func() error {
		err = t.gn.SetNames(ctx, chN)
		if err != nil {
			slog.Error("SetNames", "error", err)
		}
		return err
	})

	// Exports canonicals to GN database.
	g.Go(func() error {
		err = t.gn.SetCanonicals(ctx, chC)
		if err != nil {
			slog.Error("SetCanonicals", "error", err)
		}
		return err
	})

	// Exports full catnonical version to GN database.
	g.Go(func() error {
		err = t.gn.SetCanonicalsFull(ctx, chCF)
		if err != nil {
			slog.Error("SetCanonicalsFull", "error", err)
		}
		return err
	})

	// Exports stemmed canonical version to GN database.
	g.Go(func() error {
		err = t.gn.SetCanonicalsStem(ctx, chCS)
		if err != nil {
			slog.Error("SetCanonicalsStem", "error", err)
		}
		return err
	})

	if err = g.Wait(); err != nil {
		slog.Error("Error in go routines", "error", err)
		return err
	}

	return nil
}
