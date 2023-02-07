package option

// 控制变量
var Opt Option

type Option struct {
	ConfigPath    string        `long:"config" short:"f" description:"配置文件路径"`
	RunServe      RunServe      `command:"run" description:"启动api服务"`
	InitTable     InitTable     `command:"inittable"  description:"初始化数据库"`
	InitSuperUser InitSuperUser `command:"initsuperuser" description:"初始化超级管理员、重置超级管理员密码"`
}
