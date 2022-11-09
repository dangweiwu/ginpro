package admintpl

import (
	"gs/cli/internal/admintpl/tpl"
	"gs/pkg/utils"
	"io/fs"
	"io/ioutil"
	"os"
	"path"
)

var chmod fs.FileMode = 755

type Module struct {
	Module string
}

type AdminTpl struct {
	RootFile           string
	AdminFile          string
	MiddlerFile        string
	PkgFile            string
	SerCtxFile         string
	RouterFile         string
	ConfigFile         string
	BaseConfigFile     string
	LogFile            string
	pwd                string
	CmdFile            string
	AppTestFile        string
	AdminTestFile      string
	AdminLoginTestFile string
	AdminMockFile      string
	ScriptFile         string
	Module             Module
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
	a.CmdFile = path.Join(a.RootFile, "cmd")
	a.Module = Module{name}
	a.AppTestFile = path.Join(a.RootFile, "internal", "apptest")
	a.AdminTestFile = path.Join(a.AppTestFile, "admin_test")
	a.AdminLoginTestFile = path.Join(a.AppTestFile, "adminlogin_test")
	a.AdminMockFile = path.Join(a.AppTestFile, "adminmock")
	a.ScriptFile = path.Join(a.RootFile, "script")
	return a, nil
}

// 创建基础目录
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
	if !utils.IsExists(this.CmdFile) {
		if err := os.MkdirAll(this.CmdFile, chmod); err != nil {
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

	tmp = path.Join(this.MiddlerFile, "httplog.go")
	if err := utils.GenTpl(tpl.MidHttplog, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.MiddlerFile, "recover.go")
	if err := utils.GenTpl(tpl.MidRecover, this.Module, tmp); err != nil {
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

	// tmp = path.Join(appFile, "tpl.yaml")
	// if err := utils.GenTpl(tpl.AppYaml, this.Module, tmp); err != nil {
	// 	return err
	// }

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

	tmp = path.Join(handlerFile, "logout.go")
	if err := utils.GenTpl(tpl.AdminHandlerLogout, this.Module, tmp); err != nil {
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

	tmp = path.Join(handlerFile, "refreshToken.go")
	if err := utils.GenTpl(tpl.AdminHandlerReflashToken, this.Module, tmp); err != nil {
		return err
	}

	//tmp = path.Join(handlerFile, "initadmin.go")
	//if err := utils.GenTpl(tpl.AdminHandlerInitmain, this.Module, tmp); err != nil {
	//	return err
	//}

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

	return nil
}

// 全局配置文件
func (this *AdminTpl) genConfig() error {

	tmp := path.Join(this.ConfigFile, "config.go")
	if err := utils.GenTpl(tpl.ProjectConfig, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.BaseConfigFile, "config.yaml")
	if err := utils.GenTpl(tpl.ProjectYaml, this.Module, tmp); err != nil {
		return err
	}

	//es日志mapping
	tmp = path.Join(this.BaseConfigFile, "logmapping.json")
	if err := utils.GenTpl(tpl.LogMapping, this.Module, tmp); err != nil {
		return err
	}

	return nil
}

// router
func (this *AdminTpl) genRouter() error {

	tmp := path.Join(this.RouterFile, "do.go")
	if err := utils.GenTpl(tpl.RouterDo, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.RouterFile, "router.go")
	if err := utils.GenTpl(tpl.RouterRouter, this.Module, tmp); err != nil {
		return err
	}

	irouter := path.Join(this.RouterFile, "irouter")
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

// main.go
func (this *AdminTpl) genMain() error {
	tmp := path.Join(this.RootFile, "main.go")
	if err := utils.GenTpl(tpl.Main, this.Module, tmp); err != nil {
		return err
	}

	return nil
}

func (this *AdminTpl) genCmd() error {
	//cmd
	tmp := path.Join(this.RootFile, "cmd", "superman.go")
	if err := utils.GenTpl(tpl.CmdSuperTpl, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.RootFile, "cmd", "server.go")
	if err := utils.GenTpl(tpl.CmdServeTpl, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.RootFile, "cmd", "superman_test.go")
	if err := utils.GenTpl(tpl.CmdSupertestTpl, this.Module, tmp); err != nil {
		return err
	}

	return nil
}

func (this *AdminTpl) genApptest() error {

	if !utils.IsExists(this.AppTestFile) {
		if err := os.MkdirAll(this.AppTestFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.AdminTestFile) {
		if err := os.MkdirAll(this.AdminTestFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.AdminLoginTestFile) {
		if err := os.MkdirAll(this.AdminLoginTestFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.AdminMockFile) {
		if err := os.MkdirAll(this.AdminMockFile, chmod); err != nil {
			return err
		}
	}
	if !utils.IsExists(this.ScriptFile) {
		if err := os.MkdirAll(this.ScriptFile, chmod); err != nil {
			return err
		}
	}

	//gen admin_test tpl
	for k, v := range map[string]string{
		"admin_del_test.go":      tpl.AdminDelTest,
		"admin_get_test.go":      tpl.AdminGetTest,
		"admin_main_test.go":     tpl.AdminMainTest,
		"admin_post_test.go":     tpl.AdminPostTest,
		"admin_put_test.go":      tpl.AdminPutTest,
		"admin_resetpwd_test.go": tpl.AdminResetpwdTest,
		"my_get_test.go":         tpl.MyGetTest,
		"my_put_test.go":         tpl.MyPutTest,
		"my_resetpwd_test.go":    tpl.MyResetpwdTest,
	} {
		tmp := path.Join(this.AdminTestFile, k)
		if err := utils.GenTpl(v, this.Module, tmp); err != nil {
			return err
		}
	}

	//gen adminlogin_test tpl
	for k, v := range map[string]string{
		"admin_login_test.go":        tpl.AdminLoginTest,
		"admin_logout_test.go":       tpl.AdminLogoutTest,
		"admin_main_test.go":         tpl.AdminLoginMainTest,
		"admin_refreshtoken_test.go": tpl.AdminRefreshtokenTest,
	} {
		tmp := path.Join(this.AdminLoginTestFile, k)
		if err := utils.GenTpl(v, this.Module, tmp); err != nil {
			return err
		}
	}

	//gen adminmock

	for k, v := range map[string]string{
		"admin_user_mock.go":      tpl.AdminMock,
		"admin_user_mock_test.go": tpl.AdminMockTest,
	} {
		tmp := path.Join(this.AdminMockFile, k)
		if err := utils.GenTpl(v, this.Module, tmp); err != nil {
			return err
		}
	}

	//gen task
	tmp := path.Join(this.ScriptFile, "cover.awk")
	if err := utils.GenTpl(tpl.CoverAwkScript, this.Module, tmp); err != nil {
		return err
	}

	tmp = path.Join(this.RootFile, "Taskfile.yml")
	if err := ioutil.WriteFile(tmp, []byte(tpl.TestTask), 755); err != nil {
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
		this.genCmd,
		this.genApptest,
	}
	for _, v := range job {
		if err := v(); err != nil {
			return err
		}
	}

	return nil
}
