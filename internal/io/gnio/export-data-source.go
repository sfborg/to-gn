package gnio

import (
	"context"
	"log/slog"
	"time"

	"github.com/gnames/gnidump/pkg/ent/model"
	"github.com/sfborg/to-gn/internal/ent/ds"
)

func (g *gnio) SetDataSource(d model.DataSource) error {
	var err error
	dsi := ds.DataSourcesInfoMap[g.cfg.DataSourceID]
	now := time.Now()
	ctx := context.Background()

	res := model.DataSource{
		ID:              g.cfg.DataSourceID,
		UUID:            dsi.UUID,
		Title:           d.Title,
		TitleShort:      dsi.TitleShort,
		DOI:             d.DOI,
		Description:     d.Description,
		Version:         g.cfg.DataSourceReleaseVersion,
		RevisionDate:    g.cfg.DataSourceReleaseDate,
		WebsiteURL:      dsi.HomeURL,
		DataURL:         dsi.DataURL,
		OutlinkURL:      dsi.OutlinkURL,
		IsOutlinkReady:  dsi.IsOutlinkReady,
		IsCurated:       ds.IsCurated(g.cfg.DataSourceID),
		IsAutoCurated:   ds.IsAutoCurated(g.cfg.DataSourceID),
		HasTaxonData:    ds.HasClassification(g.cfg.DataSourceID),
		RecordCount:     d.RecordCount,
		VernRecordCount: d.VernRecordCount,
		UpdatedAt:       now,
	}

	err = g.deleteDataSource(ctx)
	if err != nil {
		return err
	}

	err = g.insertDataSource(ctx, res)
	if err != nil {
		return err
	}

	return nil
}

func (g *gnio) NamesNum(ctx context.Context, d *model.DataSource) error {
	var res int
	q := `
SELECT count(*)
  FROM name_string_indices
  WHERE data_source_id = $1
`
	err := g.db.QueryRow(ctx, q, g.cfg.DataSourceID).Scan(&res)
	if err != nil {
		return err
	}

	d.RecordCount = res
	return nil
}

func (g *gnio) VernNum(ctx context.Context, d *model.DataSource) error {
	var res int
	q := `
SELECT count(*)
  FROM vernacular_string_indices
  WHERE data_source_id = $1
`
	err := g.db.QueryRow(ctx, q, g.cfg.DataSourceID).Scan(&res)
	if err != nil {
		return err
	}

	d.VernRecordCount = res
	return nil
}

func (g *gnio) deleteDataSource(ctx context.Context) error {
	var err error
	q := `
DELETE
	FROM data_sources
	WHERE id = $1
`
	_, err = g.db.Exec(ctx, q, g.cfg.DataSourceID)
	if err != nil {
		return err
	}

	return nil
}

func (g *gnio) insertDataSource(
	ctx context.Context,
	d model.DataSource,
) error {
	q := `
INSERT INTO data_sources 
  (id, uuid, title, title_short, version, revision_date,
   doi, citation, authors, description,
   website_url, data_url, outlink_url, is_outlink_ready,
   is_curated, is_auto_curated, has_taxon_data,
   record_count, vern_record_count, updated_at)
  VALUES
		($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12,
     $13, $14, $15, $16, $17, $18, $19, $20)
`
	_, err := g.db.Exec(ctx, q,
		d.ID, d.UUID, d.Title, d.TitleShort, d.Version,
		d.RevisionDate, d.DOI, d.Citation, d.Authors, d.Description,
		d.WebsiteURL, d.DataURL, d.OutlinkURL, d.IsOutlinkReady,
		d.IsCurated, d.IsAutoCurated, d.HasTaxonData,
		d.RecordCount, d.VernRecordCount, d.UpdatedAt,
	)
	if err != nil {
		slog.Error("In insertDataSource", "error", err)
		return err
	}
	return nil
}
