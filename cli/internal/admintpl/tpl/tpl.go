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

	//go:embed admin_model_logForm.tpl
	AdminModelLogform string

	//go:embed admin_model_model.tpl
	AdminModelModel string

	//go:embed admin_handler_del.tpl
	AdminHandlerDel string

	//go:embed admin_handler_get.tpl
	AdminHandlerGet string

	//go:embed admin_handler_login.tpl
	AdminHandlerLogin string

	//go:embed admin_handler_post.tpl
	AdminHandlerPost string

	//go:embed admin_handler_put.tpl
	AdminHandlerPut string

	//go:embed admin_handler_reflashToken.tpl
	AdminHandlerReflashToken string

	//go:embed admin_logic_del.tpl
	AdminLogicDel string

	//go:embed admin_logic_get.tpl
	AdminLogicGet string

	//go:embed admin_logic_login.tpl
	AdminLogicLogin string

	//go:embed admin_logic_post.tpl
	AdminLogicPost string

	//go:embed admin_logic_put.tpl
	AdminLogicPut string

	//go:embed admin_logic_reflashToken.tpl
	AdminLogicReflashToken string

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

	//go:embed main.tpl
	Main string

	//go:embed app_yaml.tpl
	AppYaml string
)
