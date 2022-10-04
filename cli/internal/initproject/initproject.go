package initproject

import (
	"fmt"
	"gs/cli/internal/initproject/genframework"
	"os"

	"github.com/spf13/cobra"
)

/*
对项目进行初始化
创建目录
复制基础模板 代码
*/

// type InitProject struct {
// 	ProjectName string `validate:"empty=false"` //初始化项目名称
// }

// var InitProjectConfig = &InitProject{}

var Cmd = &cobra.Command{
	Use:   "init [projectName]",
	Long:  "init project, made project direct and file",
	Short: "init project",
	Run: func(cmd *cobra.Command, args []string) {

		if len(args) == 0 {
			fmt.Println("缺少项目名称")
			cmd.Help()
			os.Exit(1)
		}
		pname := args[0]

		// if err := validate.Validate(InitProjectConfig); err != nil {
		// 	fmt.Println(err)
		// 	fmt.Println()
		// 	fmt.Println(cmd.UsageString())
		// 	os.Exit(1)
		// }

		obj, err := genframework.NewGenFramework(pname)
		if err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		if err := obj.Do(); err != nil {
			fmt.Println(err)
			os.Exit(1)
		}
		fmt.Println(args[0] + "已生成")
		fmt.Println()
		fmt.Println("please run:")
		fmt.Println()

		fmt.Printf(`cd ./%s &&
go mod init %s && 
go mod tidy`, pname, pname)
	},
}

// func init() {
// 	Cmd.Flags().StringVarP(&InitProjectConfig.ProjectName, "name", "n", "", "project name,this name is project module name")
// }
