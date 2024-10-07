package config

import (
	"log/slog"
	"os"
	"strconv"
)

func LoadEnv(c *Config) {
	slog.Info("Updating config using environment variables")
	opts := strOpts()
	opts = append(opts, intOpts()...)
	for _, opt := range opts {
		opt(c)
	}
}

func strOpts() []Option {
	var res []Option

	envToOpt := map[string]func(string) Option{
		"TO_GN_DB_DATABASE": OptDbDatabase,
		"TO_GN_DB_HOST":     OptDbHost,
		"TO_GN_DB_USER":     OptDbUser,
		"TO_GN_DB_PASS":     OptDbPass,
	}

	for envVar, optFunc := range envToOpt {
		envVal := os.Getenv(envVar)
		if envVal != "" {
			res = append(res, optFunc(envVal))
		}
	}

	return res
}

func intOpts() []Option {
	var res []Option
	envToOpt := map[string]func(int) Option{
		"TO_GN_JOBS_NUM": OptJobsNum,
	}
	for envVar, optFunc := range envToOpt {
		val := os.Getenv(envVar)
		if val == "" {
			continue
		}
		i, err := strconv.Atoi(val)
		if err != nil {
			slog.Warn("Cannot convert to int", "env", envVar, "value", val)
			continue
		}
		res = append(res, optFunc(i))
	}
	return res
}
