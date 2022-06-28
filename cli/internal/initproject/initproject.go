package initproject

import (
	"fmt"
	"gs/cli/internal/initproject/genframework"
	"os"

	"github.com/spf13/cobra"
	"gopkg.in/dealancer/validate.v2"
)

/*
对项目进行初始化
创建目录
复制基础模板 代码
*/

type InitProject struct {
	ProjectName string `validate:"empty=false"` //初始化项目名称
}

var InitProjectConfig = &InitProject{}

var Cmd = &cobra.Command{
	Use:   "init",
	Long:  "init project, made project direct and file",
	Short: "init project",
	Run: func(cmd *cobra.Command, args []string) {
		if err := validate.Validate(InitProjectConfig); err != nil {
			fmt.Println(err)
			fmt.Println()
			fmt.Println(cmd.UsageString())
			os.Exit(1)
		}

		obj, err := genframework.NewGenFramework(InitProjectConfig.ProjectName)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		if err := obj.Do(); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
	},
}

func init() {
	Cmd.Flags().StringVarP(&InitProjectConfig.ProjectName, "name", "n", "", "project name,this name is project module name")
}
