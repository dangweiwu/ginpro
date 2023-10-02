package option

import (
	"errors"
	"fmt"
	"github.com/dangweiwu/template/apitpl"
)

//生成api模板 包括增删查改

type ApiTemlate struct{}

func (this *ApiTemlate) Usage() string {
	return `api-name

  生成api模板
  包括通用增删查改`
}

func (this *ApiTemlate) Execute(args []string) error {
	if len(args) == 0 {
		return errors.New("缺少api-name")
	}
	apiName := args[0]
	err := apitpl.GenCode(apiName)
	if err != nil {
		return err
	}
	fmt.Println(apiName + "已生成")

	return nil
}
