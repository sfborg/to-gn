package sfio

import (
	"context"
	"database/sql"
	"log/slog"
	"strings"

	"github.com/gnames/coldp/ent/coldp"
	"github.com/gnames/gnidump/pkg/ent/model"
	"github.com/gnames/gnparser"
	"github.com/gnames/gnparser/ent/parsed"
	"github.com/sfborg/to-gn/internal/ent/ds"
)

var dsinfo = ds.DataSourcesInfoMap

func (s *sfio) GetNameIndices(
	ctx context.Context,
	chIdx chan<- []model.NameStringIndex) error {

	p := <-s.gnpPool
	defer func() { s.gnpPool <- p }()

	slog.Info("Creating breadcrumb hierarchies")
	err := s.buildHierarchy()
	if err != nil {
		slog.Error("Cannot build hierarchies", "error", err)
		return err
	}

	err = s.getTaxa(p, chIdx)
	if err != nil {
		slog.Error("Cannot load taxon data for NameStringIndex", "errror", err)
		return err
	}

	err = s.getSynonyms(p, chIdx)
	if err != nil {
		slog.Error("Cannot load synonym data for NameStringIndex", "errror", err)
		return err
	}

	err = s.getBareNames(p, chIdx)
	if err != nil {
		slog.Error("Cannot load bare names NameStringIndex", "errror", err)
		return err
	}

	return nil
}

func (s *sfio) getTaxa(
	p gnparser.GNparser,
	chIdx chan<- []model.NameStringIndex,
) error {
	start := 1
	offset := s.cfg.BatchSize
	for {
		res, err := s.queryTaxon(p, start, offset)
		if err != nil {
			return err
		}
		start += offset + 1
		if len(res) == 0 {
			break
		}
		chIdx <- res
	}
	return nil
}

func (s *sfio) queryTaxon(
	p gnparser.GNparser,
	start, offset int,
) ([]model.NameStringIndex, error) {
	q := `
SELECT
	t.id, t.id, n.id, n.gn_scientific_name_string, t.gn_global_id,
	t.gn_local_id, n.code_id, n.rank_id, t.status_id
  FROM taxon t
		JOIN name n
			ON n.id = t.name_id
	WHERE t.ROWID BETWEEN $1 AND $2
`
	res := make([]model.NameStringIndex, 0, offset)
	rows, err := s.db.Query(q, start, start+offset)
	if err != nil {
		slog.Error("Cannot run taxon query for NameStringIndex", "error", err)
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		nsi, err := s.processNameStringIndexRow(p, rows)
		if err != nil {
			return nil, err
		}

		res = append(res, *nsi)
	}

	return res, nil
}

func (s *sfio) getSynonyms(
	p gnparser.GNparser,
	chIdx chan<- []model.NameStringIndex,
) error {
	start := 1
	offset := s.cfg.BatchSize
	for {
		res, err := s.querySynonym(p, start, offset)
		if err != nil {
			return err
		}
		start += offset + 1
		if len(res) == 0 {
			break
		}
		chIdx <- res
	}
	return nil
}

func (s *sfio) querySynonym(
	p gnparser.GNparser,
	start, offset int,
) ([]model.NameStringIndex, error) {
	q := `
SELECT
	s.id, t.id, n.id, n.gn_scientific_name_string, t.gn_global_id,
	t.gn_local_id, n.code_id, n.rank_id, s.status_id
  FROM synonym s
	  JOIN taxon t ON s.taxon_id = t.id
	  JOIN name n ON n.id = s.name_id
	WHERE s.ROWID BETWEEN $1 AND $2
`
	res := make([]model.NameStringIndex, 0, offset)
	rows, err := s.db.Query(q, start, start+offset)
	if err != nil {
		slog.Error("Cannot run taxon query for NameStringIndex", "error", err)
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		nsi, err := s.processNameStringIndexRow(p, rows)
		if err != nil {
			return nil, err
		}
		res = append(res, *nsi)
	}

	return res, nil
}

func (s *sfio) getBareNames(
	p gnparser.GNparser,
	chIdx chan<- []model.NameStringIndex,
) error {
	start := 1
	offset := s.cfg.BatchSize
	for {
		res, err := s.queryBareNames(p, start, offset)
		if err != nil {
			return err
		}
		start += offset + 1
		if len(res) == 0 {
			break
		}
		chIdx <- res
	}
	return nil
}

func (s *sfio) queryBareNames(
	p gnparser.GNparser,
	start, offset int,
) ([]model.NameStringIndex, error) {
	q := `
	SELECT 
	  id, gn_scientific_name_string, scientific_name, code_id, rank_id
	  FROM name
	    WHERE
	      id NOT IN
	      (SELECT DISTINCT name_id
	         FROM (
	           SELECT name_id FROM taxon
	             UNION ALL
	           SELECT name_id FROM synonym
	         )
	      )
	      AND ROWID BETWEEN $1 AND $2
`
	res := make([]model.NameStringIndex, 0, offset)
	rows, err := s.db.Query(q, start, start+offset)
	if err != nil {
		slog.Error("Cannot run taxon query for NameStringIndex", "error", err)
		return nil, err
	}
	defer rows.Close()

	for rows.Next() {
		var nsi model.NameStringIndex
		var name, sciName, code, rank string
		err := rows.Scan(
			&nsi.NameID, &name, &sciName, &code, &rank,
		)
		if err != nil {
			slog.Error("Cannot get bare name data for NameStringIndex", "error", err)
			return nil, err
		}
		nsi.RecordID = "bare-name-" + nsi.NameID
		nsi.TaxonomicStatus = strNorm(coldp.BareNameTS.String())
		nsi.AcceptedRecordID = nsi.RecordID
		nsi.LocalID = nsi.NameID
		parsed := p.ParseName(name)
		nsi.NameStringID = parsed.VerbatimID
		dsi, hasDsi := dsinfo[s.cfg.DataSourceID]
		if hasDsi {
			nsi.OutlinkID = dsi.OutlinkID(nameInfo(nsi, parsed))
		}

		res = append(res, nsi)
	}

	return res, nil
}

func getCodeID(code string) int {
	switch coldp.NewNomCode(code) {
	case coldp.Zoological:
		return 1
	case coldp.Botanical:
		return 2
	case coldp.Bacterial:
		return 3
	case coldp.Virus:
		return 4
	// case coldp.Cultivars: return 5
	default:
		return 0
	}
}

func nameInfo(nsi model.NameStringIndex, parsed parsed.Parsed) ds.NameInfo {
	res := ds.NameInfo{
		RecordID:         nsi.RecordID,
		AcceptedRecordID: nsi.AcceptedRecordID,
		LocalID:          nsi.LocalID,
		GlobalID:         nsi.GlobalID,
		NameID:           nsi.NameID,
	}
	if !parsed.Parsed {
		return res
	}

	res.Canonical = parsed.Canonical.Simple
	res.CanonicalFull = parsed.Canonical.Full
	return res
}

func (s *sfio) processNameStringIndexRow(
	p gnparser.GNparser,
	rows *sql.Rows,
) (*model.NameStringIndex, error) {
	var nsi model.NameStringIndex
	var name, code, rank string

	err := rows.Scan(
		&nsi.RecordID, &nsi.AcceptedRecordID, &nsi.NameID,
		&name, &nsi.GlobalID, &nsi.LocalID, &code, &rank, &nsi.TaxonomicStatus,
	)
	if err != nil {
		slog.Error("Cannot get taxon data for NameStringIndex", "error", err)
		return nil, err
	}

	nsi.CodeID = getCodeID(code)
	nsi.TaxonomicStatus = strNorm(nsi.TaxonomicStatus)
	nsi.Rank = strNorm(rank)
	parsed := p.ParseName(name)
	nsi.NameStringID = parsed.VerbatimID
	c, cRank, cID := s.getBreadcrumbs(nsi.AcceptedRecordID)
	nsi.Classification = c
	nsi.ClassificationRanks = cRank
	nsi.ClassificationIDs = cID
	dsi, hasDsi := dsinfo[s.cfg.DataSourceID]
	if hasDsi {
		nsi.OutlinkID = dsi.OutlinkID(nameInfo(nsi, parsed))
	}
	return &nsi, nil
}

func strNorm(s string) string {
	s = strings.ToLower(s)
	return strings.ReplaceAll(s, "_", " ")
}
