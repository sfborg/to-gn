package cmd

import (
	"fmt"
	"os"

	togn "github.com/sfborg/to-gn/pkg"
	"github.com/sfborg/to-gn/pkg/config"
	"github.com/spf13/cobra"
)

type flagFunc func(cmd *cobra.Command)

func dataSourceFlag(cmd *cobra.Command) {
	i, _ := cmd.Flags().GetInt("source")
	if i >= 0 {
		opts = append(opts, config.OptDataSourceID(i))
	}
}

func dataSourceReleaseFlag(cmd *cobra.Command) {
	s, _ := cmd.Flags().GetString("source-release-date")
	if s != "" {
		opts = append(opts, config.OptDataSourceRelease(s))
	}
}

func versionFlag(cmd *cobra.Command) {
	b, _ := cmd.Flags().GetBool("version")
	if b {
		version := togn.GetVersion()
		fmt.Printf(
			"\nVersion: %s\nBuild:   %s\n\n",
			version.Version,
			version.Build,
		)
		os.Exit(0)
	}
}

func jobsNumFlag(cmd *cobra.Command) {
	i, _ := cmd.Flags().GetInt("jobs-number")
	if i > 0 {
		opts = append(opts, config.OptJobsNum(i))
	}
}
