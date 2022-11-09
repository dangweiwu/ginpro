package tpl

import (
	_ "embed"
)

var (

	//go:embed serctx.tpl
	SerctxTpl string

	//go:embed mid_token.tpl
	MidTokenTpl string

	//go:embed mid_regmidler.tpl
	MidRegTpl string

	//go:embed mid_logincode.tpl
	MidLoginCodeTpl string

	//go:embed mid_cors.tpl
	MidCorsTpl string

	//go:embed pkg_password.tpl
	PkgPasswordTpl string

	//go:embed pkg_jwt.tpl
	PkgJwtTpl string

	//go:embed pkg_jwt_config.tpl
	PkgJwtCfgTpl string

	//go:embed admin_model_const.tpl
	AdminModelConstTpl string

	// //go:embed admin_model_logForm.tpl
	// AdminModelLogform string

	//go:embed admin_model_model.tpl
	AdminModelModel string

	//go:embed admin_handler_del.tpl
	AdminHandlerDel string

	//go:embed admin_handler_get.tpl
	AdminHandlerGet string

	//go:embed admin_handler_login.tpl
	AdminHandlerLogin string

	//go:embed admin_handler_logout.tpl
	AdminHandlerLogout string

	//go:embed admin_handler_post.tpl
	AdminHandlerPost string

	//go:embed admin_handler_put.tpl
	AdminHandlerPut string

	//go:embed admin_handler_reflashToken.tpl
	AdminHandlerReflashToken string

	// //go:embed admin_logic_del.tpl
	// AdminLogicDel string

	// //go:embed admin_logic_get.tpl
	// AdminLogicGet string

	// //go:embed admin_logic_login.tpl
	// AdminLogicLogin string

	// //go:embed admin_logic_post.tpl
	// AdminLogicPost string

	// //go:embed admin_logic_put.tpl
	// AdminLogicPut string

	// //go:embed admin_logic_reflashToken.tpl
	// AdminLogicReflashToken string

	//go:embed admin_router.tpl
	AdminRouter string

	//go:embed app_router.tpl
	AppRouter string

	//go:embed app_db.tpl
	AppDb string

	//go:embed project_config.tpl
	ProjectConfig string

	//go:embed project_yaml.tpl
	ProjectYaml string

	//go:embed router_do.tpl
	RouterDo string

	//go:embed router_router.tpl
	RouterRouter string

	//go:embed router_irouter.tpl
	RouterIRouter string

	//go:embed main.tpl
	Main string

	//go:embed app_yaml.tpl
	AppYaml string

	//go:embed admin_config.tpl
	AdminConfig string

	//go:embed admin_handler_myget.tpl
	AdminHandlerMyGet string

	//go:embed admin_handler_myput.tpl
	AdminHandlerMyPut string

	//go:embed admin_handler_mysetpwd.tpl
	AdminHandlerMySetpwd string

	//go:embed admin_handler_resetpwd.tpl
	AdminHandlerResetpwd string

	//go:embed mid_httplog.tpl
	MidHttplog string

	//go:embed mid_recover.tpl
	MidRecover string

	//go:embed cmd_superman.tpl
	CmdSuperTpl string

	//go:embed cmd_serve.tpl
	CmdServeTpl string

	//go:embed cmd_supertest.tpl
	CmdSupertestTpl string

	//go:embed apptest/admin_test/admin_del_test.tpl
	AdminDelTest string

	//go:embed apptest/admin_test/admin_get_test.tpl
	AdminGetTest string

	//go:embed apptest/admin_test/admin_main_test.tpl
	AdminMainTest string

	//go:embed apptest/admin_test/admin_post_test.tpl
	AdminPostTest string

	//go:embed apptest/admin_test/admin_put_test.tpl
	AdminPutTest string

	//go:embed apptest/admin_test/admin_resetpwd_test.tpl
	AdminResetpwdTest string

	//go:embed apptest/admin_test/my_get_test.tpl
	MyGetTest string

	//go:embed apptest/admin_test/my_put_test.tpl
	MyPutTest string

	//go:embed apptest/admin_test/my_resetpwd_test.tpl
	MyResetpwdTest string

	//go:embed apptest/adminlogin_test/admin_login_test.tpl
	AdminLoginTest string

	//go:embed apptest/adminlogin_test/admin_logout_test.tpl
	AdminLogoutTest string

	//go:embed apptest/adminlogin_test/admin_main_test.tpl
	AdminLoginMainTest string

	//go:embed apptest/adminlogin_test/admin_refreshtoken_test.tpl
	AdminRefreshtokenTest string

	//go:embed apptest/adminmock/mock.tpl
	AdminMock string

	//go:embed apptest/adminmock/mock_test.tpl
	AdminMockTest string

	//go:embed apptest/total.awk
	CoverAwkScript string

	//go:embed apptest/Taskfile.yml
	TestTask string

	//go:embed logmapping.json
	LogMapping string
)
