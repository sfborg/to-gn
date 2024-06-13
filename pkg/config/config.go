package config

type Config struct {
	// DataSourceID may provide information which DataSaource ID should be
	// used for importing data to GN database.
	DataSourceID int

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
}

type Option func(*Config)

func OptDataSourceID(i int) Option {
	return func(cfg *Config) {
		cfg.DataSourceID = i
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
	res := Config{
		DataSourceID: 0,
		DbDatabase:   "gnames",
		DbHost:       "0.0.0.0",
		DbUser:       "postgres",
		DbPass:       "postgres",
	}
	for _, opt := range opts {
		opt(&res)
	}
	return res
}
