package sfio

import (
	"github.com/gnames/gnidump/pkg/ent/model"
)

func (s *sfio) GetDataSource(
	ds *model.DataSource) error {
	var err error
	q := `
SELECT col__title, col__description, col__doi
  FROM metadata
  LIMIT 1
`
	row := s.sfga.Db().QueryRow(q)
	err = row.Scan(&ds.Title, &ds.Description, &ds.DOI)
	if err != nil {
		return err
	}
	return nil
}
