package admintpl

import (
	"gs/cli/internal/admintpl/tpl"
	"gs/pkg/utils"
	"io/fs"
	"os"
	"path"
)

var chmod fs.FileMode = 755

type Module struct {
	Module string
}

type AdminTpl struct {
	RootFile       string
	AdminFile      string
	MiddlerFile    string
	PkgFile        string
	SerCtxFile     string
	RouterFile     string
	ConfigFile     string
	BaseConfigFile string
	LogFile        string
	pwd            string
	Module         Module
}

func NewGenAdmin(name string) (*AdminTpl, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}
	a := &AdminTpl{RootFile: path.Join(wd, name), pwd: wd}

	a.AdminFile = path.Join(a.RootFile, "internal", "app", "admin")
	a.MiddlerFile = path.Join(a.RootFile, "internal", "middler")
	a.PkgFile = path.Join(a.RootFile, "internal", "pkg")
	a.SerCtxFile = path.Join(a.RootFile, "internal", "serctx")
	a.RouterFile = path.Join(a.RootFile, "internal", "router")
	a.ConfigFile = path.Join(a.RootFile, "internal", "config")
	a.BaseConfigFile = path.Join(a.RootFile, "config")
	a.LogFile = path.Join(a.RootFile, "log")
	a.Module = Module{name}
	return a, nil
}

//创建基础目录
func (this *AdminTpl) genDir() error {

	if !utils.IsExists(this.AdminFile) {
		if err := os.MkdirAll(this.AdminFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.MiddlerFile) {
		if err := os.MkdirAll(this.MiddlerFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.PkgFile) {
		if err := os.MkdirAll(this.PkgFile, chmod); err != nil {
			return err
		}
	}

	if !utils.IsExists(this.SerCtxFile) {
		if err := os.MkdirAll(this.SerCtxFile, chmod); err != nil {
			return err
		}
	}

	if !utils.IsExists(this.PkgFile) {
		if err := os.MkdirAll(this.PkgFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.RouterFile) {
		if err := os.MkdirAll(this.RouterFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.ConfigFile) {
		if err := os.MkdirAll(this.ConfigFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.BaseConfigFile) {
		if err := os.MkdirAll(this.BaseConfigFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.LogFile) {
		if err := os.MkdirAll(this.LogFile, chmod); err != nil {
			return err
		}
	}
	return nil
}

func (this *AdminTpl) genSerctx() error {
	pt := path.Join(this.SerCtxFile, "serctx.go")
	if err := utils.GenTpl(tpl.SerctxTpl, this.Module, pt); err != nil {
		return err
	}
	return nil
}

func (this *AdminTpl) genMiddler() error {
	tmp := path.Join(this.MiddlerFile, "cors.go")
	if err := utils.GenTpl(tpl.MidCorsTpl, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.MiddlerFile, "logincode.go")
	if err := utils.GenTpl(tpl.MidLoginCodeTpl, this.Module, tmp); err != nil {
		return err
	}
	tmp = path.Join(this.MiddlerFile, "regmiddler.go")
	if err := utils.GenTpl(tpl.MidRegTpl, this.Module, tmp); err != nil {
		return err
	}
	tmp = path.Join(this.MiddlerFile, "token.go")
	if err := utils.GenTpl(tpl.MidTokenTpl, this.Module, tmp); err != nil {
		return err
	}
	return nil
}

func (this *AdminTpl) genPkg() error {
	tmp := path.Join(this.PkgFile, "password.go")
	if err := utils.GenTpl(tpl.PkgPasswordTpl, this.Module, tmp); err != nil {
		return err
	}

	jwtFile := path.Join(this.PkgFile, "jwtx")
	jwtConfig := path.Join(jwtFile, "jwtconfig")
	if !utils.IsExists(jwtFile) {
		if err := os.MkdirAll(jwtFile, chmod); err != nil {
			return err
		}

		if err := os.MkdirAll(jwtConfig, chmod); err != nil {
			return err
		}
	}

	tmp = path.Join(jwtFile, "jwt.go")
	if err := utils.GenTpl(tpl.PkgJwtTpl, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(jwtConfig, "config.go")
	if err := utils.GenTpl(tpl.PkgJwtCfgTpl, this.Module, tmp); err != nil {
		return err
	}
	return nil
}

func (this *AdminTpl) genAdmin() error {
	
	tmp := path.Join(this.AdminFile, "router.go")
	if err := utils.GenTpl(tpl.AdminRouter, this.Module, tmp); err != nil {
		return err
	}

	//app router

	appFile := path.Join(this.RootFile, "internal", "app")

	tmp = path.Join(appFile, "regrouter.go")
	if err := utils.GenTpl(tpl.AppRouter, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(appFile, "regdb.go")
	if err := utils.GenTpl(tpl.AppDb, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(appFile, "tpl.yaml")
	if err := utils.GenTpl(tpl.AppYaml, this.Module, tmp); err != nil {
		return err
	}

	adminmodelFile := path.Join(this.AdminFile, "adminmodel")
	if !utils.IsExists(adminmodelFile) {
		if err := os.MkdirAll(adminmodelFile, chmod); err != nil {
			return err
		}
	}

	handlerFile := path.Join(this.AdminFile, "handler")
	if !utils.IsExists(handlerFile) {
		if err := os.MkdirAll(handlerFile, chmod); err != nil {
			return err
		}
	}


	configFile := path.Join(this.AdminFile, "adminconfig")
	if !utils.IsExists(configFile) {
		if err := os.MkdirAll(configFile, chmod); err != nil {
			return err
		}
	}
	//config
	tmp = path.Join(configFile, "config.go")
	if err := utils.GenTpl(tpl.AdminConfig, this.Module, tmp); err != nil {
		return err
	}



	//model
	tmp = path.Join(adminmodelFile, "const.go")
	if err := utils.GenTpl(tpl.AdminModelConstTpl, this.Module, tmp); err != nil {
		return err
	}

	// tmp = path.Join(adminmodelFile, "logForm.go")
	// if err := utils.GenTpl(tpl.AdminModelLogform, this.Module, tmp); err != nil {
	// 	return err
	// }

	tmp = path.Join(adminmodelFile, "model.go")
	if err := utils.GenTpl(tpl.AdminModelModel, this.Module, tmp); err != nil {
		return err
	}

	//handler
	tmp = path.Join(handlerFile, "del.go")
	if err := utils.GenTpl(tpl.AdminHandlerDel, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "get.go")
	if err := utils.GenTpl(tpl.AdminHandlerGet, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "login.go")
	if err := utils.GenTpl(tpl.AdminHandlerLogin, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "post.go")
	if err := utils.GenTpl(tpl.AdminHandlerPost, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "put.go")
	if err := utils.GenTpl(tpl.AdminHandlerPut, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "reflashToken.go")
	if err := utils.GenTpl(tpl.AdminHandlerReflashToken, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "initadmin.go")
	if err := utils.GenTpl(tpl.AdminHandlerInitmain, this.Module, tmp); err != nil {
		return err
	}

	
	tmp = path.Join(handlerFile, "resetPwd.go")
	if err := utils.GenTpl(tpl.AdminHandlerResetpwd, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "myget.go")
	if err := utils.GenTpl(tpl.AdminHandlerMyGet, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "myput.go")
	if err := utils.GenTpl(tpl.AdminHandlerMyPut, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(handlerFile, "mySetPwd.go")
	if err := utils.GenTpl(tpl.AdminHandlerMySetpwd, this.Module, tmp); err != nil {
		return err
	}


	//logic
	// tmp = path.Join(logicFile, "del.go")
	// if err := utils.GenTpl(tpl.AdminLogicDel, this.Module, tmp); err != nil {
	// 	return err
	// }

	// tmp = path.Join(logicFile, "get.go")
	// if err := utils.GenTpl(tpl.AdminLogicGet, this.Module, tmp); err != nil {
	// 	return err
	// }

	// tmp = path.Join(logicFile, "login.go")
	// if err := utils.GenTpl(tpl.AdminLogicLogin, this.Module, tmp); err != nil {
	// 	return err
	// }

	// tmp = path.Join(logicFile, "post.go")
	// if err := utils.GenTpl(tpl.AdminLogicPost, this.Module, tmp); err != nil {
	// 	return err
	// }

	// tmp = path.Join(logicFile, "put.go")
	// if err := utils.GenTpl(tpl.AdminLogicPut, this.Module, tmp); err != nil {
	// 	return err
	// }

	// tmp = path.Join(logicFile, "reflashToken.go")
	// if err := utils.GenTpl(tpl.AdminLogicReflashToken, this.Module, tmp); err != nil {
	// 	return err
	// }

	// adminrouter


	return nil
}

//全局配置文件
func (this *AdminTpl) genConfig() error {

	tmp := path.Join(this.ConfigFile, "config.go")
	if err := utils.GenTpl(tpl.ProjectConfig, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.BaseConfigFile, "config.yaml")
	if err := utils.GenTpl(tpl.ProjectYaml, this.Module, tmp); err != nil {
		return err
	}

	return nil
}

//router
func (this *AdminTpl) genRouter() error {


	tmp := path.Join(this.RouterFile, "do.go")
	if err := utils.GenTpl(tpl.RouterDo, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.RouterFile, "router.go")
	if err := utils.GenTpl(tpl.RouterRouter, this.Module, tmp); err != nil {
		return err
	}

	irouter := path.Join(this.RouterFile,"irouter")	
	if !utils.IsExists(irouter) {
		if err := os.MkdirAll(irouter, chmod); err != nil {
			return err
		}
	}
	tmp = path.Join(irouter, "irouter.go")
	if err := utils.GenTpl(tpl.RouterIRouter, this.Module, tmp); err != nil {
		return err
	}

	return nil
}

//main.go
func (this *AdminTpl) genMain() error {
	tmp := path.Join(this.RootFile, "main.go")
	if err := utils.GenTpl(tpl.Main, this.Module, tmp); err != nil {
		return err
	}
	return nil
}

func (this *AdminTpl) Do() error {

	job := []func() error{
		this.genDir,
		this.genConfig,
		this.genSerctx,
		this.genPkg,
		this.genMiddler,
		this.genRouter,
		this.genAdmin,
		this.genMain,
	}
	for _, v := range job {
		if err := v(); err != nil {
			return err
		}
	}

	return nil
}
