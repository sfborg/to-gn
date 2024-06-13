package cmd

import (
	"github.com/sfga/to-gn/pkg/config"
	"github.com/spf13/cobra"
)

type flagFunc func(cmd *cobra.Command)

func dataSourceFlag(cmd *cobra.Command) {
	i, _ := cmd.Flags().GetInt("source")
	if i >= 0 {
		opts = append(opts, config.OptDataSourceID(i))
	}
}
