package admintpl

import (
	_ "embed"
)

var (

	//go:embed tpl/main.tpl
	MainTpl string
	//go:embed tpl/config/config.tpl
	ConfigYamlTpl string
	//go:embed tpl/core/config/config.tpl
	ConfigTpl string

	//go:embed tpl/core/app/regDb.tpl
	RedDbTpl string

	//go:embed tpl/core/app/regApiRouter.tpl
	RegRouterTpl string

	//go:embed tpl/core/app/admin/router.tpl
	AdminRouterTpl string

	//go:embed tpl/core/app/admin/adminmodel/model.tpl
	AdminModelTpl string

	//go:embed tpl/core/app/admin/api/create.tpl
	AdminCreateTpl string

	//go:embed tpl/core/app/admin/api/query.tpl
	AdminQueryTpl string

	//go:embed tpl/core/app/admin/api/update.tpl
	AdminUpdateTpl string

	//go:embed tpl/core/app/admin/api/del.tpl
	AdminDelTpl string

	//go:embed tpl/core/app/admin/api/resetPwd.tpl
	AdminResetPwdTpl string

	//go:embed tpl/core/app/my/mymodel/model.tpl
	MyModelTpl string

	//go:embed tpl/core/app/my/router.tpl
	MyRouterTpl string

	//go:embed tpl/core/app/my/mymodel/const.tpl
	MyModelConstTpl string

	//go:embed tpl/core/app/my/api/info.tpl
	MyInfoTpl string

	//go:embed tpl/core/app/my/api/update.tpl
	MyUpdateTpl string

	//go:embed tpl/core/app/my/api/updatePwd.tpl
	MyUpdatePwdTpl string

	//go:embed tpl/core/app/my/api/login.tpl
	LoginTpl string

	//go:embed tpl/core/app/my/api/logout.tpl
	LogoutTpl string

	//go:embed tpl/core/app/my/api/refreshToken.tpl
	RefreshTokenTpl string

	//go:embed tpl/core/ctx/dbCtx.tpl
	DbCtxTpl string

	//go:embed tpl/core/ctx/serverCtx.tpl
	ServerCtxTpl string

	//go:embed tpl/core/middler/cors.tpl
	MiddlerCorsTpl string

	//go:embed tpl/core/middler/loginCode.tpl
	MiddlerLoginCodeTpl string

	//go:embed tpl/core/middler/httpLog.tpl
	MiddlerHttpLogTpl string

	//go:embed tpl/core/middler/recover.tpl
	MiddlerRecoverTpl string

	//go:embed tpl/core/middler/token.tpl
	MiddlerTokenTpl string

	//go:embed tpl/core/middler/prom.tpl
	MiddlerPromTpl string

	//go:embed tpl/core/middler/regMidler.tpl
	MiddlerRegMiddler string

	//go:embed tpl/option/option.tpl
	OptionTpl string

	//go:embed tpl/option/initTable.tpl
	OptionInitTableTpl string

	//go:embed tpl/option/initSuperUser.tpl
	OptionInitSuperUserTpl string

	//go:embed tpl/option/runServer.tpl
	OptionRunServerTpl string

	//go:embed tpl/core/pkg/password.tpl
	PkgPasswordTpl string

	//go:embed tpl/core/pkg/jwtx/jwtxconfig/config.tpl
	JwtConfigTpl string

	//go:embed tpl/core/pkg/jwtx/jwt.tpl
	JwtTpl string

	//go:embed tpl/core/router/do.tpl
	RouterDoTpl string

	//go:embed tpl/core/router/router.tpl
	RouterTpl string

	//go:embed tpl/core/router/irouter/irouter.tpl
	RouterITpl string

	//go:embed tpl/Taskfile.yaml.tpl
	TaskfileYamlTpl string

	//go:embed tpl/script/cover.awk
	CoverAwkTpl string

	//调试相关
	//go:embed tpl/core/testtool/testctx/ctx.tpl
	TestCtxTpl string

	//go:embed tpl/core/testtool/adminUser.tpl
	TestAdminUserTpl string

	//go:embed tpl/core/testtool/server.tpl
	TestServerTpl string

	//go:embed tpl/core/testtool/config.tpl
	TestConfigTpl string

	//go:embed tpl/core/app/admin/api_test/create_test.tpl
	TestAdminCreateTpl string
	//go:embed tpl/core/app/admin/api_test/main_test.tpl
	TestAdminMainTpl string
	//go:embed tpl/core/app/admin/api_test/del_test.tpl
	TestAdminDelTpl string
	//go:embed tpl/core/app/admin/api_test/query_test.tpl
	TestAdminQueryTpl string
	//go:embed tpl/core/app/admin/api_test/update_test.tpl
	TestAdminUpdateTpl string
	//go:embed tpl/core/app/admin/api_test/resetPwd_test.tpl
	TestAdminResetPwdTpl string

	//go:embed tpl/core/app/my/api_test/main_test.tpl
	TestMyMainTpl string
	//go:embed tpl/core/app/my/api_test/update_test.tpl
	TestMyUpdateTpl string
	//go:embed tpl/core/app/my/api_test/info_test.tpl
	TestMyInfoTpl string
	//go:embed tpl/core/app/my/api_test/login_test.tpl
	TestMyLoginTpl string
	//go:embed tpl/core/app/my/api_test/logout_test.tpl
	TestMyLogoutTpl string
	//go:embed tpl/core/app/my/api_test/refreshToken_test.tpl
	TestMyRefreshTokenTpl string
	//go:embed tpl/core/app/my/api_test/updatePwd_test.tpl
	TestMyUpdatePwdTpl string

	//go:embed tpl/core/pkg/lg/lg.tpl
	LgTpl string

	//role
	//go:embed tpl/core/app/sys/api/info.tpl
	SysApiInfoTpl string

	//go:embed tpl/core/app/sys/api/act.tpl
	SysApiActTpl string

	//go:embed tpl/core/app/sys/api_test/info_test.tpl
	SysApiInfoTestTpl string

	//go:embed tpl/core/app/sys/api_test/act_test.tpl
	SysApiActTestTpl string

	//go:embed tpl/core/app/sys/api_test/main_test.tpl
	SysApiMainTestTpl string
	//go:embed tpl/core/app/sys/apiRoute.tpl
	SysApiRouteTpl string

	//go:embed tpl/core/app/sys/sysmodel/act.tpl
	SysModelActTpl string
	//go:embed tpl/core/app/sys/sysmodel/vo.tpl
	SysModelVoTpl string
)
