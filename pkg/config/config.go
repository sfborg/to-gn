package config

import (
	"os"
	"path/filepath"
)

var (
	// tag of the sfga repo to get correct schema version.
	verSFGA = "v0.3.24"
	// jobsNum is the default number of concurrent jobs to run.
	jobsNum = 5
)

type Config struct {
	// MinVersionSFGA sets minimal version of SFGA archive schema
	// that is needed for data extraction.
	MinVersionSFGA string

	// DataSourceID may provide information which DataSaource ID should be
	// used for importing data to GN database.
	DataSourceID int

	// DataSourceRelease provides release date of the imported data.
	DataSourceRelease string

	// DataSourceReleaseDate provides details when this version of
	// data was released.
	DataSourceReleaseDate string

	// CacheDir keeps temporary directories for extracting and accessing
	// SFGA data.
	CacheDir string

	// SfgaDir is where SFGA database is downloaded.
	SfgaDir string

	// DbDatabase is the name of the GN databsae, default is `gnames`.
	DbDatabase string

	// DbHost is the host of the GN database.
	DbHost string

	// DbUser is the user of the GN database with write privileges.
	DbUser string

	// DbPass is the password to the GN database for the given DbUser.
	DbPass string

	// JobsNum is the number of concurrent jobs to run.
	JobsNum int

	// BatchSize sets the size of batch for insert statements.
	BatchSize int

	// WithFlatClassification is true if the 'flat' version of classification
	// is preferrable instead of parent/child classification. Note that if
	// flat classification does not exist, the classification breadcrumbs will
	// stay empty even if parent/child do exist. By default this option is
	// false and parent/child classification is preferrable over 'flat' one.
	WithFlatClassification bool
}

type Option func(*Config)

func OptDataSourceID(i int) Option {
	return func(cfg *Config) {
		cfg.DataSourceID = i
	}
}

func OptDataSourceRelease(s string) Option {
	return func(cfg *Config) {
		cfg.DataSourceRelease = s
	}
}

func OptDbDatabase(s string) Option {
	return func(cfg *Config) {
		cfg.DbDatabase = s
	}
}

func OptDbHost(s string) Option {
	return func(cfg *Config) {
		cfg.DbHost = s
	}
}

func OptDbUser(s string) Option {
	return func(cfg *Config) {
		cfg.DbUser = s
	}
}

func OptDbPass(s string) Option {
	return func(cfg *Config) {
		cfg.DbPass = s
	}
}

func OptJobsNum(i int) Option {
	return func(cfg *Config) {
		cfg.JobsNum = i
	}
}

func OptWithFlatClassification(b bool) Option {
	return func(cfg *Config) {
		cfg.WithFlatClassification = b
	}
}

func New(opts ...Option) Config {
	tmpDir := os.TempDir()
	cacheDir, err := os.UserCacheDir()
	if err != nil {
		cacheDir = tmpDir
	}

	cacheDir = filepath.Join(cacheDir, "sfborg", "to", "gn")

	res := Config{
		MinVersionSFGA: verSFGA,
		DataSourceID:   0,
		CacheDir:       cacheDir,
		DbDatabase:     "gnames",
		DbHost:         "0.0.0.0",
		DbUser:         "postgres",
		DbPass:         "postgres",
		// Max is 64K, we keep it less to avoid rounding error.
		BatchSize: 63_000,
		JobsNum:   4,
	}
	for _, opt := range opts {
		opt(&res)
	}

	res.SfgaDir = filepath.Join(cacheDir, "db")
	return res
}
