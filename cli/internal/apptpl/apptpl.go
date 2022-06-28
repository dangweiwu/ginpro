package apptpl

import (
	"fmt"
	"gs/cli/internal/apptpl/tpl"
	"gs/pkg/yamconfig"
	"os"

	"github.com/spf13/cobra"
	"gopkg.in/dealancer/validate.v2"
)

type MethodTpl struct {
	Method  string `validate:"empty=true | one_of=all,get,post,put,delete,route,model"` //类型
	FileDir string `validate:"empty=false"`
}

var MethodTplConfig = &MethodTpl{}
var TplConfig = &tpl.AppTplConfig{}
var Cmd = &cobra.Command{
	Use:   "tpl",
	Long:  "gen api app template",
	Short: "gen api app template",
	Run: func(cmd *cobra.Command, args []string) {

		if err := validate.Validate(MethodTplConfig); err != nil {
			fmt.Println(err)
			fmt.Println()
			fmt.Println(cmd.UsageString())
			os.Exit(1)
		}
		if err := yamconfig.Load(MethodTplConfig.FileDir, TplConfig); err != nil {
			fmt.Println(err)
			fmt.Println()
			os.Exit(1)
		}

		if err := GenTemplate(MethodTplConfig.Method, *TplConfig); err != nil {
			fmt.Println(err)
			fmt.Println()
			os.Exit(1)
		}

	},
}

func init() {
	Cmd.Flags().StringVarP(&MethodTplConfig.Method, "method", "m", "all", "project name,this name is project package name [all,get,post,put,delete,route,model]")
	Cmd.Flags().StringVarP(&MethodTplConfig.FileDir, "file", "f", "./tpl.yaml", "api tpl config yaml")
}
