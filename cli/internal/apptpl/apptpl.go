package apptpl

import (
	"fmt"
	"gs/cli/internal/apptpl/tpl"
	"gs/pkg/utils"
	"os"

	"github.com/spf13/cobra"
)

// type MethodTpl struct {
// 	Method  string `validate:"empty=true | one_of=all,get,post,put,delete,route,model"` //类型
// 	FileDir string `validate:"empty=false"`
// }

// var MethodTplConfig = &MethodTpl{}
var TplConfig = &tpl.AppTplConfig{}
var Cmd = &cobra.Command{
	Use:   "app [appname] [routerType]",
	Long:  "gen app api template",
	Short: "gen app api  template",
	Run: func(cmd *cobra.Command, args []string) {

		// if err := validate.Validate(MethodTplConfig); err != nil {
		// 	fmt.Println(err)
		// 	fmt.Println()
		// 	fmt.Println(cmd.UsageString())
		// 	os.Exit(1)
		// }
		// if err := yamconfig.Load(MethodTplConfig.FileDir, TplConfig); err != nil {
		// 	fmt.Println(err)
		// 	fmt.Println()
		// 	os.Exit(1)
		// }

		//组织名字
		appname := ""
		routerType := "Jwt"
		if len(args) != 0 {
			appname = args[0]
		} else {
			fmt.Println("缺少AppName参数")
			cmd.Help()
			os.Exit(1)
		}

		if len(args) > 1 {
			routerType = args[1]
		}

		if len(appname) == 0 {
			fmt.Println("缺少有效App名称")
			cmd.Help()
			os.Exit(1)
		}
		appname = utils.FirstUpper(appname)

		modname, err := utils.GetModName()
		if err != nil {
			fmt.Println("缺少模块名称", err)
			cmd.Help()
			os.Exit(1)
		}

		TplConfig.AppName = appname
		TplConfig.Module = modname
		TplConfig.ModelName = appname
		TplConfig.TableName = appname
		TplConfig.RouterType = routerType
		TplConfig.RouterUrl = utils.FirstLower(appname)
		TplConfig.HasDelete = true
		TplConfig.HasGet = true
		TplConfig.HasPost = true
		TplConfig.HasPut = true

		if err := GenTemplate("all", *TplConfig); err != nil {
			fmt.Println(err)
			fmt.Println()
			os.Exit(1)
		}
		fmt.Println("add model to regdb.go")
		fmt.Println("add route to regrouter.go")

	},
}

// func init() {
// 	// Cmd.Flags().StringVarP(&MethodTplConfig.Method, "method", "m", "all", "project name,this name is project package name [all,get,post,put,delete,route,model]")
// 	// Cmd.Flags().StringVarP(&MethodTplConfig.FileDir, "file", "f", "./", "api tpl config yaml")
// }
