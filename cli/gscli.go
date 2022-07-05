package cli

import (
	"gs/cli/internal/admintpl"
	"gs/cli/internal/apptpl"
	"gs/cli/internal/initproject"

	"github.com/spf13/cobra"
)

var Cmd = &cobra.Command{
	Use:   "gscli",
	Short: "goserver cli tool",
	Long:  "goserver cli tool",
}

func init() {
	Cmd.AddCommand(initproject.Cmd)
	Cmd.AddCommand(apptpl.Cmd)
	Cmd.AddCommand(admintpl.Cmd)
}
