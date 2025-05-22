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
	"github.com/sfborg/to-gn/pkg/ds"
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
	t.col__id, t.col__id, n.col__id, n.gn__scientific_name_string,
	t.gn__global_id, t.gn__local_id, n.col__code_id, n.col__rank_id,
	t.col__status_id, col__kingdom, sf__kingdom_id, col__phylum,
	sf__phylum_id, col__subphylum, sf__subphylum_id, col__class,
	sf__class_id, col__subclass, sf__subclass_id, col__order, sf__order_id,
	col__suborder, sf__suborder_id, col__superfamily, sf__superfamily_id,
	col__family, sf__family_id, col__subfamily, sf__subfamily_id,
	col__tribe, sf__tribe_id, col__subtribe, sf__subtribe_id, t.col__genus,
	sf__genus_id, col__subgenus, sf__subgenus_id, col__section,
	sf__section_id, col__species, sf__species_id
  FROM taxon t
		JOIN name n
			ON n.col__id = t.col__name_id
	WHERE t.ROWID BETWEEN $1 AND $2
`
	res := make([]model.NameStringIndex, 0, offset)
	rows, err := s.sfga.Db().Query(q, start, start+offset)
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
	s.col__id, t.col__id, n.col__id, n.gn__scientific_name_string,
	t.gn__global_id, t.gn__local_id, n.col__code_id, n.col__rank_id,
	s.col__status_id, col__kingdom, sf__kingdom_id, col__phylum,
	sf__phylum_id, col__subphylum, sf__subphylum_id, 
	col__class, sf__class_id, col__subclass, sf__subclass_id, col__order,
	sf__order_id, col__suborder, sf__suborder_id, col__superfamily,
	sf__superfamily_id, col__family, sf__family_id, col__subfamily,
	sf__subfamily_id, col__tribe, sf__tribe_id, col__subtribe,
	sf__subtribe_id, t.col__genus, sf__genus_id, col__subgenus, sf__subgenus_id,
	col__section, sf__section_id, col__species, sf__species_id
  FROM synonym s
	  JOIN taxon t ON s.col__taxon_id = t.col__id
	  JOIN name n ON n.col__id = s.col__name_id
	WHERE s.ROWID BETWEEN $1 AND $2
`
	res := make([]model.NameStringIndex, 0, offset)
	rows, err := s.sfga.Db().Query(q, start, start+offset)
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
	  col__id, gn__scientific_name_string, col__scientific_name,
	  col__code_id, col__rank_id
	  FROM name
	    WHERE
	      col__id NOT IN
	      (SELECT DISTINCT col__name_id
	         FROM (
	           SELECT col__name_id FROM taxon
	             UNION ALL
	           SELECT col__name_id FROM synonym
	         )
	      )
	      AND ROWID BETWEEN $1 AND $2
`
	res := make([]model.NameStringIndex, 0, offset)
	rows, err := s.sfga.Db().Query(q, start, start+offset)
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
	var kingdom, phylum, subphylum, class, subclass, order, suborder string
	var superfamily, family, subfamily, tribe, subtribe, genus string
	var subgenus, section, species string
	var kingdomID, phylumID, subphylumID, classID, subclassID, orderID string
	var suborderID, superfamilyID, familyID, subfamilyID, tribeID string
	var subtribeID, genusID, subgenusID, sectionID, speciesID string

	err := rows.Scan(
		&nsi.RecordID, &nsi.AcceptedRecordID, &nsi.NameID,
		&name, &nsi.GlobalID, &nsi.LocalID, &code, &rank, &nsi.TaxonomicStatus,
		&kingdom, &kingdomID, &phylum, &phylumID, &subphylum, &subphylumID,
		&class, &classID, &subclass, &subclassID, &order, &orderID,
		&suborder, &suborderID, &superfamily, &superfamilyID, &family, &familyID,
		&subfamily, &subfamilyID, &tribe, &tribeID, &subtribe, &subtribeID,
		&genus, &genusID, &subgenus, &subgenusID, &section, &sectionID, &species,
		&speciesID,
	)

	flatClsf := map[string]string{
		"kingdom": kingdom, "phylum": phylum, "subphylum": subphylum,
		"class": class, "subclass": subclass, "order": order, "suborder": suborder,
		"superfamily": superfamily, "family": family, "subfamily": subfamily,
		"tribe": tribe, "subtribe": subtribe, "genus": genus,
		"subgenus": subgenus, "section": section, "species": species,
		"kingdom_id": kingdomID, "phylum_id": phylumID, "subphylum_id": subphylumID,
		"class_id": classID, "subclass_id": subclassID, "order_id": orderID,
		"suborder_id": suborderID, "superfamily_id": superfamilyID,
		"family_id": familyID, "subfamily_id": subfamilyID, "tribe_id": tribeID,
		"subtribe_id": subtribeID, "genus_id": genusID, "subgenus_id": subgenusID,
		"section_id": sectionID, "species_id": speciesID,
	}

	if err != nil {
		slog.Error("Cannot get taxon data for NameStringIndex", "error", err)
		return nil, err
	}

	nsi.CodeID = getCodeID(code)
	nsi.TaxonomicStatus = strNorm(nsi.TaxonomicStatus)
	nsi.Rank = strNorm(rank)
	parsed := p.ParseName(name)
	nsi.NameStringID = parsed.VerbatimID
	c, cRank, cID := s.getBreadcrumbs(nsi.AcceptedRecordID, flatClsf)
	nsi.Classification = c
	nsi.ClassificationRanks = cRank
	nsi.ClassificationIDs = cID

	dsi, hasDsi := dsinfo[s.cfg.DataSourceID]
	if hasDsi && dsi.OutlinkID != nil {
		nsi.OutlinkID = dsi.OutlinkID(nameInfo(nsi, parsed))
	}
	return &nsi, nil
}

func strNorm(s string) string {
	s = strings.ToLower(s)
	return strings.ReplaceAll(s, "_", " ")
}
