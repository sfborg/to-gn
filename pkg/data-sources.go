package togn

import (
	"context"
	"log/slog"

	"github.com/gnames/gnidump/pkg/ent/model"
	"golang.org/x/sync/errgroup"
)

func (t *togn) processDataSources() error {
	var err error
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()
	g, ctx := errgroup.WithContext(ctx)
	var ds model.DataSource

	// get data about the datasource from SFGArchive
	g.Go(func() error {
		err = t.sf.GetDataSource(&ds)
		if err != nil {
			slog.Error("GetDataSource", "error", err)
		}
		return err
	})

	// find how many name indices
	g.Go(func() error {
		err = t.gn.NamesNum(ctx, &ds)
		if err != nil {
			slog.Error("NamesNum", "error", err)
		}
		return err
	})

	// find how many vernacular name indices.
	g.Go(func() error {
		err = t.gn.VernNum(ctx, &ds)
		if err != nil {
			slog.Error("VernNus", "error", err)
		}
		return err
	})

	if err = g.Wait(); err != nil {
		slog.Error("Error in go routines", "error", err)
		return err
	}

	err = t.gn.SetDataSource(ds)
	if err != nil {
		slog.Error("Error in adding DataSource", "error", err)
		return err
	}
	return nil
}
