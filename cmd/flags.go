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
