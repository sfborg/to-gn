package config

type Config struct {
	DataSourceID int
}

type Option func(*Config)

func OptDataSourceID(i int) Option {
	return func(cfg *Config) {
		cfg.DataSourceID = i
	}
}

func New(opts ...Option) Config {
	res := Config{
		DataSourceID: -1,
	}
	for _, opt := range opts {
		opt(&res)
	}
	return res
}
