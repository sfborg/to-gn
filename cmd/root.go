/*
Copyright © 2024 Dmitry Mozzherin <dmozzherin@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/
package cmd

import (
	_ "embed"
	"fmt"
	"log/slog"
	"os"
	"path/filepath"

	"github.com/gnames/gnsys"
	"github.com/sfborg/sflib"
	"github.com/sfborg/to-gn/internal/io"
	"github.com/sfborg/to-gn/internal/io/gnio"
	"github.com/sfborg/to-gn/internal/io/sfio"
	"github.com/sfborg/to-gn/pkg/config"
	"github.com/sfborg/to-gn/pkg/togn"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

//go:embed to-gn.yaml
var configText string

var (
	opts []config.Option
)

type fConfig struct {
	DataSourceID int
	DbDatabase   string
	DbHost       string
	DbUser       string
	DbPass       string
	JobsNum      int
}

// rootCmd represents the base command when called without any subcommands
var rootCmd = &cobra.Command{
	Use:   "to-gn <sfga-file>",
	Short: "Converts sfga archive to `gnames` database entries",
	Long: `Takes a path to an SFGA archive and installs its data
to a GlobalNames database.`,
	Run: func(cmd *cobra.Command, args []string) {
		versionFlag(cmd)
		flags := []flagFunc{
			dataSourceFlag, dataSourceReleaseFlag, jobsNumFlag,
		}
		for _, v := range flags {
			v(cmd)
		}

		cfg := config.New(opts...)

		if len(args) != 1 {
			cmd.Help()
			os.Exit(0)
		}

		err := io.ResetCache(cfg)
		if err != nil {
			slog.Error("Cannot reset cache", "dir", cfg.CacheDir, "error", err)
			os.Exit(1)
		}

		// path to SFGA archive
		sfgaPath := args[0]
		slog.Info("Exporting SFGA data to GN database", "path", sfgaPath)

		sfga := sflib.NewSfga()

		// initiate GNverifier database
		gn, err := gnio.New(cfg)
		if err != nil {
			slog.Error("Cannot initialize GN database", "error", err)
			os.Exit(1)
		}

		// initiate SFGA archive
		sf := sfio.New(cfg, sfga)

		// initiate togn instance
		tgn, err := togn.New(cfg, sf, gn)
		if err != nil {
			slog.Error("Cannot initialize ToGN instance", "error", err)
			os.Exit(1)
		}

		// transfer SFGA data to GNverifier database
		err = tgn.Export(sfgaPath)
		if err != nil {
			slog.Error("Cannot import sfga file to GN database",
				"path", sfgaPath,
				"error", err,
			)
			os.Exit(1)
		}
	},
}

// Execute adds all child commands to the root command and sets flags appropriately.
// This is called by main.main(). It only needs to happen once to the rootCmd.
func Execute() {
	err := rootCmd.Execute()
	if err != nil {
		os.Exit(1)
	}
}

func init() {
	cobra.OnInitialize(initConfig)

	rootCmd.Flags().IntP("source", "s", -1, "Data Source ID")
	rootCmd.Flags().StringP(
		"source-release-date",
		"r", "", "Data Source Release Date",
	)
	rootCmd.Flags().IntP("jobs-number", "j", 0, "Concurrent jobs number")
	rootCmd.Flags().BoolP("version", "V", false, "Show version number")
}

// initConfig reads in config file and ENV variables if set.
func initConfig() {
	configFile := "to-gn"
	configDir, err := os.UserConfigDir()
	if err != nil {
		slog.Error("Cannot find user's config directory.", "error", err)
		os.Exit(1)
	}
	viper.AddConfigPath(configDir)
	viper.SetConfigName(configFile)

	viper.BindEnv("DbDatabase", "TO_GN_DB_DATABASE")
	viper.BindEnv("DbHost", "TO_GN_DB_HOST")
	viper.BindEnv("DbUser", "TO_GN_DB_USER")
	viper.BindEnv("DbPass", "TO_GN_DB_PASS")
	viper.BindEnv("JobsNum", "TO_GN_JOBS_NUM")
	viper.AutomaticEnv()

	configPath := filepath.Join(configDir, fmt.Sprintf("%s.yaml", configFile))
	touchConfigFile(configPath)

	// If a config file is found, read it in.
	if err := viper.ReadInConfig(); err == nil {
		slog.Info("Using config file.", "file", viper.ConfigFileUsed())
	}

	opts = getOpts()
}

// getOpts imports data from the configuration file. These settings can be
// overriden by command line flags.
func getOpts() []config.Option {
	var opts []config.Option
	cfg := &fConfig{}
	err := viper.Unmarshal(cfg)
	if err != nil {
		slog.Error("Cannot unmarshal config.", "error", err)
		os.Exit(1)
	}

	if cfg.DataSourceID != 0 {
		opts = append(opts, config.OptDataSourceID(cfg.DataSourceID))
	}
	if cfg.DbDatabase != "" {
		opts = append(opts, config.OptDbDatabase(cfg.DbDatabase))
	}
	if cfg.DbHost != "" {
		opts = append(opts, config.OptDbHost(cfg.DbHost))
	}
	if cfg.DbUser != "" {
		opts = append(opts, config.OptDbUser(cfg.DbUser))
	}
	if cfg.DbPass != "" {
		opts = append(opts, config.OptDbPass(cfg.DbPass))
	}
	if cfg.JobsNum != 0 {
		opts = append(opts, config.OptJobsNum(cfg.JobsNum))
	}
	return opts
}

// touchConfigFile checks if config file exists, and if not, it gets created.
func touchConfigFile(configPath string) {
	exists, _ := gnsys.FileExists(configPath)
	if exists {
		return
	}

	slog.Info("Creating config file.", "file", configPath)
	createConfig(configPath)
}

// createConfig creates config file.
func createConfig(path string) {
	err := gnsys.MakeDir(filepath.Dir(path))
	if err != nil {
		slog.Error("Cannot create config dir.", "error", err)
		os.Exit(1)
	}

	err = os.WriteFile(path, []byte(configText), 0644)
	if err != nil {
		slog.Error("Cannot create config file.", "error", err)
		os.Exit(1)
	}
}
