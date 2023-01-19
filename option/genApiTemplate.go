package option

import (
	"errors"
	"gs/pkg/utils"
	"gs/template/apitpl/tpl"
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
	appName := utils.FirstUpper(apiName)
	modelName, err := utils.GetModName()
	if err != nil {
		return err
	}
	var TplConfig = &tpl.AppTplConfig{}

	TplConfig.AppName = appName
	TplConfig.Module = modelName
	TplConfig.ModelName = appName
	TplConfig.TableName = appName
	TplConfig.RouterType = "Jwt"
	TplConfig.RouterUrl = utils.FirstLower(apiName)
	TplConfig.HasDelete = true
	TplConfig.HasGet = true
	TplConfig.HasPost = true
	TplConfig.HasPut = true

	return nil
}
