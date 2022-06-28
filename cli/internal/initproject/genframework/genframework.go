package genframework

import (
	_ "embed"
	"errors"
	"fmt"
	"gs/cli/internal/initproject/genframework/tpl"
	"gs/pkg/utils"
	"io/fs"
	"os"
	"path"
)

/*
生成基础框架
*/
var chmod fs.FileMode = 755

var (
	//go:embed tpl/main.tpl
	MainTpl string
	//go:embed tpl/config.tpl
	ConfigTpl string

	//go:embed tpl/serctx.tpl
	SerctxTpl string

	//go:embed tpl/router.tpl
	RouterTpl string

	//go:embed tpl/routerdo.tpl
	DoTpl string

	//go:embed tpl/approuter.tpl
	AppRouterTpl string

	//go:embed tpl/regdb.tpl
	RegDbTpl string

	//go:embed tpl/appconfigyaml.tpl
	AppConfigTpl string

	//go:embed tpl/configyaml.tpl
	ConfigYamlTpl string
)

type GenFramework struct {
	RootFile string
	pwd      string
}

func NewGenFramework(name string) (*GenFramework, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	return &GenFramework{RootFile: name, pwd: wd}, nil
}

//创建目录
func (this *GenFramework) genFrameworkDir() error {

	pt := path.Join(this.pwd, this.RootFile)

	if utils.IsExists(pt) {
		return errors.New(this.RootFile + "已存在")
	}

	if err := os.MkdirAll(pt, chmod); err != nil {
		return err
	}
	configFile := path.Join(pt, "config")
	if err := os.MkdirAll(configFile, chmod); err != nil {
		return err
	}
	internal := path.Join(pt, "internal")
	if err := os.MkdirAll(internal, chmod); err != nil {
		return err
	}
	config := path.Join(internal, "config")
	if err := os.MkdirAll(config, chmod); err != nil {
		return err
	}
	middler := path.Join(internal, "middler")
	if err := os.MkdirAll(middler, chmod); err != nil {
		return err
	}

	router := path.Join(internal, "router")
	if err := os.MkdirAll(router, chmod); err != nil {
		return err
	}

	serctx := path.Join(internal, "serctx")
	if err := os.MkdirAll(serctx, chmod); err != nil {
		return err
	}

	app := path.Join(internal, "app")
	if err := os.MkdirAll(app, chmod); err != nil {
		return err
	}

	pkg := path.Join(internal, "pkg")
	if err := os.MkdirAll(pkg, chmod); err != nil {
		return err
	}

	return nil
}

//创建go文件
func (this *GenFramework) genGoFile() error {
	root := path.Join(this.pwd, this.RootFile)
	vl := tpl.ModuleValue{Module: this.RootFile}

	mainFile := path.Join(root, "main.go")
	if err := utils.GenTpl(MainTpl, vl, mainFile); err != nil {
		return err
	}
	internal := path.Join(root, "internal")
	configFile := path.Join(internal, "config", "config.go")
	if err := utils.GenTpl(ConfigTpl, vl, configFile); err != nil {
		return err
	}

	serctx := path.Join(internal, "serctx", "serctx.go")
	if err := utils.GenTpl(SerctxTpl, vl, serctx); err != nil {
		return err
	}

	router := path.Join(internal, "router", "router.go")
	if err := utils.GenTpl(RouterTpl, vl, router); err != nil {
		return err
	}

	do := path.Join(internal, "router", "do.go")
	if err := utils.GenTpl(DoTpl, vl, do); err != nil {
		return err
	}

	approuter := path.Join(internal, "app", "regrouter.go")
	if err := utils.GenTpl(AppRouterTpl, vl, approuter); err != nil {
		return err
	}

	regdb := path.Join(internal, "app", "regdb.go")
	if err := utils.GenTpl(RegDbTpl, vl, regdb); err != nil {
		return err
	}

	apicfg := path.Join(internal, "app", "tpl.yaml")
	if err := utils.GenTpl(AppConfigTpl, nil, apicfg); err != nil {
		return err
	}

	configyaml := path.Join(root, "config", "config.yaml")
	if err := utils.GenTpl(ConfigYamlTpl, vl, configyaml); err != nil {
		return err
	}

	return nil
}

func (this *GenFramework) Do() error {
	if err := this.genFrameworkDir(); err != nil {
		return err
	}
	if err := this.genGoFile(); err != nil {
		return err
	}
	fmt.Println(this.RootFile + "已生成")
	return nil
}
