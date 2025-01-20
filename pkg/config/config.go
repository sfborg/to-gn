package config

import (
	"os"
	"path/filepath"
)

var (
	// repoURL is the URL to the SFGA schema repository.
	repoURL = "https://github.com/sfborg/sfga"

	// tag of the sfga repo to get correct schema version.
	verSFGA = "v0.3.22"

	// schemaHash is the sha256 sum of the correponding schema version.
	schemaHash = "17cd95d6d4eaa"
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

	// CacheDbDir is where SFGA database is downloaded.
	CacheDbDir string

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

	res.CacheDbDir = filepath.Join(cacheDir, "db")
	return res
}
