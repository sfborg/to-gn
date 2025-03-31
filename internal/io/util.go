package io

import (
	"github.com/gnames/gnsys"
	"github.com/sfborg/to-gn/pkg/config"
)

func ResetCache(cfg config.Config) error {
	var err error
	root := cfg.CacheDir
	err = gnsys.MakeDir(root)
	if err != nil {
		return err
	}

	err = gnsys.CleanDir(root)
	if err != nil {
		return err
	}
	dirs := []string{
		cfg.SfgaDir,
	}
	for _, v := range dirs {
		err = gnsys.MakeDir(v)
		if err != nil {
			return err
		}
	}
	return nil
}
