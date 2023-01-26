package admintpl

import (
	"gs/template/gencode"
	"os"
	"path"
)

type GenAdminServer struct {
	code *gencode.GenCode
}

func NewGenAdminServer(name string) (*GenAdminServer, error) {
	wd, err := os.Getwd()
	if err != nil {
		return nil, err
	}

	pt := path.Join(wd, name)

	c := gencode.NewGenCode(pt, gencode.ModuleValue{Module: name, Host: gencode.Host})
	a := &GenAdminServer{c}

	return a, nil
}

func (this *GenAdminServer) InitFile() error {
	var internal = "internal"
	var app = "app"
	fileItems := []gencode.FileItem{
		{"main.go", []string{}, MainTpl},
		{"config.yaml", []string{"config"}, ConfigYamlTpl},
		{"config.go", []string{internal, "config"}, ConfigTpl},
		{"regDb.go", []string{internal, app}, RedDbTpl},
		{"regRouter.go", []string{internal, app}, RegRouterTpl},
		{"model.go", []string{internal, app, "admin", "adminmodel"}, AdminModelTpl},
		{"router.go", []string{internal, app, "admin"}, AdminRouterTpl},
		{"create.go", []string{internal, app, "admin", "api"}, AdminCreateTpl},
		{"update.go", []string{internal, app, "admin", "api"}, AdminUpdateTpl},
		{"del.go", []string{internal, app, "admin", "api"}, AdminDelTpl},
		{"query.go", []string{internal, app, "admin", "api"}, AdminQueryTpl},
		{"resetPwd.go", []string{internal, app, "admin", "api"}, AdminResetPwdTpl},
		{"model.go", []string{internal, app, "my", "mymodel"}, MyModelTpl},
		{"const.go", []string{internal, app, "my", "mymodel"}, MyModelConstTpl},
		{"router.go", []string{internal, app, "my"}, MyRouterTpl},
		{"info.go", []string{internal, app, "my", "api"}, MyInfoTpl},
		{"update.go", []string{internal, app, "my", "api"}, MyUpdateTpl},
		{"updatePwd.go", []string{internal, app, "my", "api"}, MyUpdatePwdTpl},
		{"login.go", []string{internal, app, "my", "api"}, LoginTpl},
		{"logout.go", []string{internal, app, "my", "api"}, LogoutTpl},
		{"refreshToken.go", []string{internal, app, "my", "api"}, RefreshTokenTpl},
		{"dbCtx.go", []string{internal, "ctx"}, DbCtxTpl},
		{"serverCtx.go", []string{internal, "ctx"}, ServerCtxTpl},
		{"cors.go", []string{internal, "middler"}, MiddlerCorsTpl},
		{"loginCode.go", []string{internal, "middler"}, MiddlerLoginCodeTpl},
		{"httpLog.go", []string{internal, "middler"}, MiddlerHttpLogTpl},
		{"recover.go", []string{internal, "middler"}, MiddlerRecoverTpl},
		{"token.go", []string{internal, "middler"}, MiddlerTokenTpl},
		{"regMiddler.go", []string{internal, "middler"}, MiddlerRegMiddler},
		{"option.go", []string{"option"}, OptionTpl},
		{"initTable.go", []string{"option"}, OptionInitTableTpl},
		{"initSuperUser.go", []string{"option"}, OptionInitSuperUserTpl},
		{"runServer.go", []string{"option"}, OptionRunServerTpl},

		{"password.go", []string{internal, "pkg"}, PkgPasswordTpl},
		{"config.go", []string{internal, "pkg", "jwtx", "jwtconfig"}, JwtConfigTpl},
		{"jwt.go", []string{internal, "pkg", "jwtx"}, JwtTpl},
		{"lg.go", []string{internal, "pkg", "lg"}, LgTpl},

		{"do.go", []string{internal, "router"}, RouterDoTpl},
		{"router.go", []string{internal, "router"}, RouterTpl},
		{"irouter.go", []string{internal, "router", "irouter"}, RouterITpl},
		//test相关
		{"ctx.go", []string{internal, "testtool", "testctx"}, TestCtxTpl},
		{"adminUser.go", []string{internal, "testtool"}, TestAdminUserTpl},
		{"config.go", []string{internal, "testtool"}, TestConfigTpl},
		{"server.go", []string{internal, "testtool"}, TestServerTpl},

		{"create_test.go", []string{internal, "app", "admin", "api_test"}, TestAdminCreateTpl},
		{"main_test.go", []string{internal, "app", "admin", "api_test"}, TestAdminMainTpl},
		{"del_test.go", []string{internal, "app", "admin", "api_test"}, TestAdminDelTpl},
		{"query_test.go", []string{internal, "app", "admin", "api_test"}, TestAdminQueryTpl},
		{"resetPwd_test.go", []string{internal, "app", "admin", "api_test"}, TestAdminResetPwdTpl},
		{"update_test.go", []string{internal, "app", "admin", "api_test"}, TestAdminUpdateTpl},

		{"info_test.go", []string{internal, "app", "my", "api_test"}, TestMyInfoTpl},
		{"login_test.go", []string{internal, "app", "my", "api_test"}, TestMyLoginTpl},
		{"logout_test.go", []string{internal, "app", "my", "api_test"}, TestMyLogoutTpl},
		{"main_test.go", []string{internal, "app", "my", "api_test"}, TestMyMainTpl},
		{"refreshToken_test.go", []string{internal, "app", "my", "api_test"}, TestMyRefreshTokenTpl},
		{"update_test.go", []string{internal, "app", "my", "api_test"}, TestMyUpdateTpl},
		{"updatePwd_test.go", []string{internal, "app", "my", "api_test"}, TestMyUpdatePwdTpl},
	}
	this.code.SetFileItem(fileItems)
	copyFile := []gencode.CopyFile{
		{"Taskfile.yaml", []string{}, TaskfileYamlTpl},
		{"cover.awk", []string{"script"}, CoverAwkTpl},
	}
	this.code.SetCopyFile(copyFile)
	return nil
}

func (this *GenAdminServer) GenFile() error {
	return this.code.Gen()
}

func GenAdminServerCode(name string) error {
	a, err := NewGenAdminServer(name)
	if err != nil {
		return err
	}
	a.InitFile()
	return a.GenFile()
}
