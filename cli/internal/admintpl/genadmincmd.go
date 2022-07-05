package admintpl

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
	"gopkg.in/dealancer/validate.v2"
)

type InitProject struct {
	ProjectName string `validate:"empty=false"` //初始化项目名称
}

var InitProjectConfig = &InitProject{}

var Cmd = &cobra.Command{
	Use:   "admin",
	Long:  "init project by admin, made project direct and file",
	Short: "init project by admin",
	Run: func(cmd *cobra.Command, args []string) {
		if err := validate.Validate(InitProjectConfig); err != nil {
			fmt.Println(err)
			fmt.Println()
			fmt.Println(cmd.UsageString())
			os.Exit(1)
		}

		// obj, err := genframework.NewGenFramework(InitProjectConfig.ProjectName)
		// if err != nil {
		// 	fmt.Println(err)
		// 	os.Exit(1)
		// }
		// if err := obj.Do(); err != nil {
		// 	fmt.Println(err)
		// 	os.Exit(1)
		// }

		//添加admin
		if wk, err := NewGenAdmin(InitProjectConfig.ProjectName); err != nil {
			fmt.Println(err)
			os.Exit(1)
		} else {
			if err := wk.Do(); err != nil {
				fmt.Println(err)
				os.Exit(1)
			}
			fmt.Println("项目初始化完成")
		}
	},
}

func init() {
	Cmd.Flags().StringVarP(&InitProjectConfig.ProjectName, "name", "n", "", "project name,this name is project module name")
}
