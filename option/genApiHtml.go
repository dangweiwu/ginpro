package option

import (
	"errors"
	"fmt"
	"github.com/dangweiwu/template/htmlapi"
)

type ApiHtml struct {
}

func (this *ApiHtml) Usage() string {
	return ` model_name

  生成api html 模板
  包括
	index.vue
	create.vue
	update.vue
	api.ts
`
}

func (this *ApiHtml) Execute(args []string) error {
	if len(args) == 0 {
		return errors.New("缺少模块名称")
	}
	modelName := args[0]
	err := htmlapi.GenCode(modelName)
	if err != nil {
		return err
	}
	fmt.Println(modelName + "已生成")
	return nil
}
