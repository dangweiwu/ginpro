package option

var Opt Option

type Option struct {
	Server      ServerOption `command:"server" description:"生成基础server框架"`
	AdminServer AdminServer  `command:"admin" description:"生成admin server框架"`
	ApiTemplate ApiTemlate   `command:"apitpl" description:"生成api模板"`
}
