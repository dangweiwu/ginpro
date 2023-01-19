package servertpl

import (
	_ "embed"
	"errors"
	"gs/pkg/utils"
	"gs/template/servertpl/tpl"
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

	//go:embed tpl/routeri.tpl
	RouterI string

	//go:embed tpl/approuter.tpl
	AppRouterTpl string

	//go:embed tpl/regdb.tpl
	RegDbTpl string

	//// go:embed tpl/appconfigyaml.tpl
	// AppConfigTpl string

	//go:embed tpl/configyaml.tpl
	ConfigYamlTpl string

	//go:embed tpl/cmdserve.tpl
	CmdServeTpl string
	//
	////go:embed tpl/cmdsuperman.tpl
	//CmdSuperTpl string
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

// 创建目录
func (this *GenFramework) genFrameworkDir() error {

	pt := path.Join(this.pwd, this.RootFile)

	if utils.IsExists(pt) {
		return errors.New(this.RootFile + "已存在")
	}

	if err := os.MkdirAll(pt, chmod); err != nil {
		return err
	}

	for _, v := range []string{"config", "log", "internal", "cmd"} {
		tmp := path.Join(pt, v)
		if err := os.MkdirAll(tmp, chmod); err != nil {
			return err
		}
	}
	internal := path.Join(pt, "internal")

	for _, v := range []string{"config", "middler", "router", "serctx", "app", "pkg"} {
		config := path.Join(internal, v)
		if err := os.MkdirAll(config, chmod); err != nil {
			return err
		}
	}
	router := path.Join(internal, "router")
	routerI := path.Join(router, "irouter")
	if err := os.MkdirAll(routerI, chmod); err != nil {
		return err
	}

	return nil
}

// 创建go文件
func (this *GenFramework) GenGoFile() error {
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

	routeri := path.Join(internal, "router", "irouter", "irouter.go")
	if err := utils.GenTpl(RouterI, vl, routeri); err != nil {
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

	// apicfg := path.Join(internal, "app", "tpl.yaml")
	// if err := utils.GenTpl(AppConfigTpl, vl, apicfg); err != nil {
	// 	return err
	// }

	configyaml := path.Join(root, "config", "config.yaml")
	if err := utils.GenTpl(ConfigYamlTpl, vl, configyaml); err != nil {
		return err
	}

	cmdserve := path.Join(root, "cmd", "server.go")
	if err := utils.GenTpl(CmdServeTpl, vl, cmdserve); err != nil {
		return err
	}

	//super := path.Join(root, "cmd", "superman.go")
	//if err := utils.GenTpl(CmdSuperTpl, vl, super); err != nil {
	//	return err
	//}

	return nil
}

func (this *GenFramework) Do() error {
	if err := this.genFrameworkDir(); err != nil {
		return err
	}
	if err := this.GenGoFile(); err != nil {
		return err
	}

	return nil
}
