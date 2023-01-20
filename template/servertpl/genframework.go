package servertpl

import (
	_ "embed"
	"gs/template/gencode"
	"os"
	"path"
)

/*
生成基础框架
*/
var Host = "gs"

var (
	//go:embed tpl/core/main.tpl
	MainTpl string

	//go:embed tpl/core/config/config.tpl
	ConfigTpl string

	//go:embed tpl/core/ctx/serverCtx.tpl
	SerctxTpl string

	//go:embed tpl/core/router/router.tpl
	RouterTpl string

	//go:embed tpl/core/router/routerdo.tpl
	DoTpl string

	//go:embed tpl/core/router/irouter/irouter.tpl
	IRouter string

	//go:embed tpl/core/api/regRouter.tpl
	RegRouterTpl string

	//go:embed tpl/config/configyaml.tpl
	ConfigYamlTpl string

	//go:embed  tpl/core/option/option.tpl
	OptionTpl string

	//go:embed tpl/core/option/runserver.tpl
	RunServerTpl string

	//go:embed tpl/core/api/demo/router.tpl
	DemoRouter string

	//go:embed tpl/core/api/demo/handler/info.tpl
	DemoInfo string

	//go:embed tpl/view/index.tpl
	IndexHtml string
)

type GenFramework struct {
	code *gencode.GenCode
}

func NewGenFramework(name string) (*GenFramework, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	pt := path.Join(wd, name)
	c := gencode.NewGenCode(pt, gencode.ModuleValue{Module: name, Host: Host})
	a := &GenFramework{c}
	return a, nil
}

func (this *GenFramework) InitFile() error {
	var internal = "internal"
	fileItems := []gencode.FileItem{
		{"main.go", []string{}, MainTpl},
		{"config.go", []string{internal, "config"}, ConfigTpl},
		{"serCtx.go", []string{internal, "ctx"}, SerctxTpl},
		{"router.go", []string{internal, "router"}, RouterTpl},
		{"routeDo.go", []string{internal, "router"}, DoTpl},
		{"irouter.go", []string{internal, "router", "irouter"}, IRouter},
		{"regRouter.go", []string{internal, "api"}, RegRouterTpl},
		{"option.go", []string{internal, "option"}, OptionTpl},
		{"runServer.go", []string{internal, "option"}, RunServerTpl},
		{"router.go", []string{internal, "api", "demo"}, DemoRouter},
		{"info.go", []string{internal, "api", "demo", "handler"}, DemoInfo},
		{"config.yaml", []string{"config"}, ConfigYamlTpl},
		{"index.html", []string{"view"}, IndexHtml},
	}
	this.code.SetFileItem(fileItems)
	return nil
}

func (this *GenFramework) GenFile() error {
	return this.code.Gen()
}

func GenCode(name string) error {
	a, err := NewGenFramework(name)
	if err != nil {
		return err
	}
	a.InitFile()
	return a.GenFile()
}
