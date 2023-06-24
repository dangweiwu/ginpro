package adminauthtpl

import (
	_ "embed"
)

var (

	//go:embed tpl/main.tpl
	MainTpl string
	//go:embed tpl/config/config.yaml.tpl
	ConfigYamlTpl string
	//go:embed tpl/core/config/config.tpl
	ConfigTpl string

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

	//go:embed tpl/core/middler/regMiddler.tpl
	MiddlerRegMiddler string

	//增加auth部分
	//go:embed tpl/core/middler/auth.tpl
	MiddlerAuthTpl string

	//go:embed tpl/option/option.tpl
	OptionTpl string

	//go:embed tpl/option/initTable.tpl
	OptionInitTableTpl string

	//go:embed tpl/option/initSuperUser.tpl
	OptionInitSuperUserTpl string

	//go:embed tpl/option/runServer.tpl
	OptionRunServerTpl string

	//pkg
	//go:embed tpl/core/pkg/password.tpl
	PkgPasswordTpl string

	//go:embed tpl/core/pkg/jwtx/jwtxconfig/config.tpl
	JwtConfigTpl string

	//go:embed tpl/core/pkg/jwtx/jwt.tpl
	JwtTpl string

	//go:embed tpl/core/pkg/lg/lg.tpl
	LgTpl string

	//go:embed tpl/core/pkg/tel/otel_http.tpl
	OtelHttpTpl string

	//go:embed tpl/core/pkg/fullurl/fullUrl.tpl
	PkgFullUrlTpl string

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

	//go:embed tpl/core/app/regDb.tpl
	RedDbTpl string

	//go:embed tpl/core/app/regApiRouter.tpl
	RegRouterTpl string

	//go:embed tpl/core/app/admin/apiRputer.tpl
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

	//go:embed tpl/core/app/my/apiRouter.tpl
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

	//auth

	//go:embed tpl/core/app/auth/api/authTree.tpl
	AuthTreeTpl string

	//go:embed tpl/core/app/auth/api/create.tpl
	AuthCreateTpl string

	//go:embed tpl/core/app/auth/api/delete.tpl
	AuthDeleteTpl string

	//go:embed tpl/core/app/auth/api/getUrl.tpl
	AuthGetUrlTpl string

	//go:embed tpl/core/app/auth/api/query.tpl
	AuthQueryTpl string

	//go:embed tpl/core/app/auth/api/update.tpl
	AuthUpdateTpl string

	//go:embed tpl/core/app/auth/api_test/authtree_test.tpl
	AuthTreeTestTpl string

	//go:embed tpl/core/app/auth/api_test/create_test.tpl
	AuthCreateTestTpl string

	//go:embed tpl/core/app/auth/api_test/delete_test.tpl
	AuthDeleteTestTpl string

	//go:embed tpl/core/app/auth/api_test/getUrl_test.tpl
	AuthGetUrlTestTpl string

	//go:embed tpl/core/app/auth/api_test/main_test.tpl
	AuthMainTestTpl string

	//go:embed tpl/core/app/auth/api_test/query_test.tpl
	AuthQueryTestTpl string

	//go:embed tpl/core/app/auth/api_test/update_test.tpl
	AuthUpdateTestTpl string

	//go:embed tpl/core/app/auth/authcheck/adapter.tpl
	AuthAdapterTpl string

	//go:embed tpl/core/app/auth/authcheck/authCheck.tpl
	AuthCheckTpl string

	//go:embed tpl/core/app/auth/authcheck/types.tpl
	AuthTypesTpl string

	//go:embed tpl/core/app/auth/authmodel/authModel.tpl
	AuthModelTpl string

	//go:embed tpl/core/app/auth/authmodel/authTreeModel.tpl
	AuthTreeModelTpl string

	//go:embed tpl/core/app/auth/apiRouter.tpl
	AuthApiRouterTpl string

	//role
	//go:embed tpl/core/app/role/api/create.tpl
	RoleCreateTpl string

	//go:embed tpl/core/app/role/api/delete.tpl
	RoleDeleteTpl string

	//go:embed tpl/core/app/role/api/query.tpl
	RoleQueryTpl string

	//go:embed tpl/core/app/role/api/setAuth.tpl
	RoleSetAuthTpl string

	//go:embed tpl/core/app/role/api/update.tpl
	RoleUpdateTpl string

	//go:embed tpl/core/app/role/api_test/create_test.tpl
	RoleCreateTestTpl string

	//go:embed tpl/core/app/role/api_test/delete_test.tpl
	RoleDeleteTestTpl string

	//go:embed tpl/core/app/role/api_test/main_test.tpl
	RoleMainTestTpl string

	//go:embed tpl/core/app/role/api_test/query_test.tpl
	RoleQueryTestTpl string

	//go:embed tpl/core/app/role/api_test/setAuth_test.tpl
	RoleSetAuthTestTpl string

	//go:embed tpl/core/app/role/api_test/update_test.tpl
	RoleUpdateTestTpl string

	//go:embed tpl/core/app/role/rolemodel/model.tpl
	RoleModelTpl string

	//go:embed tpl/core/app/role/apiRouter.tpl
	RoleApiRouterTpl string
)
