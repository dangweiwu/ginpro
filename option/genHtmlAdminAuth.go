package option

import (
	"errors"
	"fmt"
	"gs/template/htmladminauth"
)

type HtmlAdminAuthOpt struct {
}

func (this *HtmlAdminAuthOpt) Usage() string {
	return `project_name

  生成前端admin auth框架
`
}

func (this *HtmlAdminAuthOpt) Execute(args []string) error {
	if len(args) == 0 {
		return errors.New("缺少工程名称")
	}
	modelName := args[0]
	err := htmladminauth.GenHtmlAdminAuth(modelName)
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
