package option

var Opt Option

type Option struct {
	Server          ServerOption     `command:"server" description:"生成后端基础server框架"`
	AdminServer     AdminServer      `command:"admin" description:"生成后端admin server框架"`
	ApiTemplate     ApiTemlate       `command:"apitpl" description:"生成后端api模板"`
	AdminAuthServer AdminAuthServer  `command:"adminauth" description:"生成后端admin auth server框架"`
	ApiHtml         ApiHtml          `command:"htmlapi" description:"生成前端api html模板"`
	FrontHtml       FrontHtml        `command:"htmladmin" description:"生成前端admin框架"`
	HtmlAdminAuth   HtmlAdminAuthOpt `command:"htmladminauth" description:"生成前端admin框架"`
}
