package sfio

import (
	"github.com/gnames/gnidump/pkg/ent/model"
)

func (s *sfio) GetDataSource(
	ds *model.DataSource) error {
	var err error
	q := "SELECT title, description, doi from data_source limit 1"
	row := s.db.QueryRow(q)
	err = row.Scan(&ds.Title, &ds.Description, &ds.DOI)
	if err != nil {
		return err
	}
	return nil
}
