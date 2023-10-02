package apitpl

import (
	_ "embed"
	"github.com/dangweiwu/ginpro/pkg/utils"
	"github.com/dangweiwu/ginpro/template/gencode"
	"os"
	"path"
)

var (
	//go:embed tpl/router.tpl
	RouterTpl string

	//go:embed tpl/model/po.tpl
	ModelTpl string

	//go:embed tpl/model/create.tpl
	FormTpl string

	//go:embed tpl/model/update.tpl
	UpdateFormTpl string

	//go:embed tpl/model/vo.tpl
	VoTpl string

	//go:embed tpl/api/query.tpl
	HandlerQueryTpl string

	//go:embed tpl/api/create.tpl
	HandlerCreateTpl string

	//go:embed tpl/api/update.tpl
	HandlerUpdateTpl string

	//go:embed tpl/api/delete.tpl
	HandlerDeleteTpl string
)

type ApiApp struct {
	code  *gencode.GenCode
	model string
}

func NewApiApp(appname string) (*ApiApp, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	moduleValue := gencode.ModuleValue{}
	moduleValue.Host = gencode.Host
	mdname, err := utils.GetModName()
	if err != nil {
		return nil, err
	}
	moduleValue.Module = mdname
	moduleValue.ApiName = utils.FirstUpper(appname)
	moduleValue.ApiPackage = utils.FirstLower(appname)
	moduleValue.TableName = appname
	moduleValue.ModelName = utils.FirstUpper(appname)
	moduleValue.ModelPackage = utils.FirstLower(appname) + "model"
	moduleValue.RouterType = "Jwt"
	moduleValue.RouterUrl = utils.LowerAll(appname)
	pt := path.Join(wd, appname)
	c := gencode.NewGenCode(pt, moduleValue)
	a := &ApiApp{c, moduleValue.ModelPackage}
	return a, nil
}

func (this *ApiApp) InitFile() error {
	var api = "api"
	fileItems := []gencode.FileItem{
		{"create.go", []string{api}, HandlerCreateTpl},
		{"delete.go", []string{api}, HandlerDeleteTpl},
		{"query.go", []string{api}, HandlerQueryTpl},
		{"update.go", []string{api}, HandlerUpdateTpl},
		{"model.go", []string{this.model}, ModelTpl},
		{"create.go", []string{this.model}, FormTpl},
		{"update.go", []string{this.model}, UpdateFormTpl},
		{"vo.go", []string{this.model}, VoTpl},
		{"apiRouter.go", []string{}, RouterTpl},
	}
	this.code.SetFileItem(fileItems)
	return nil
}
func (this *ApiApp) GenFile() error {
	return this.code.Gen()
}

func GenCode(name string) error {
	a, err := NewApiApp(name)
	if err != nil {
		return err
	}
	if err := a.InitFile(); err != nil {
		return err
	}
	return a.GenFile()
}
