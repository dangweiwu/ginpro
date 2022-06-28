package gscli

import (
	"gs/gscli/internal/apptpl"
	"gs/gscli/internal/initproject"

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

}
