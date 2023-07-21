package option

import (
	"errors"
	"fmt"
	"gs/template/htmladmin"
)

type FrontHtml struct {
}

func (this *FrontHtml) Usage() string {
	return ` project_name

  生成前端admin基础框架
`
}

func (this *FrontHtml) Execute(args []string) error {
	if len(args) == 0 {
		return errors.New("缺少工程名称")
	}
	modelName := args[0]
	err := htmladmin.GenFront(modelName)
	if err != nil {
		return err
	}
	fmt.Println(modelName + "已生成")
	fmt.Println("")

	fmt.Println("请手动运行:")
	fmt.Println("cd " + modelName)
	fmt.Println("npm install")
	fmt.Println("npm run dev")

	return nil
}
