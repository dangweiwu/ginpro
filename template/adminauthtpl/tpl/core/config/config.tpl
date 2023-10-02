package config

import (
	"{{.Module}}/internal/pkg/jwtx/jwtconfig"
	"{{.Host}}/api/apiserver/apiconfig"
	"{{.Host}}/pkg/logx"
	"{{.Host}}/pkg/mysqlx/mysqlxconfig"
	"{{.Host}}/pkg/redisx/redisconfig"
)

//全局配置文件
type Config struct {
    App   App
	Api   apiconfig.ApiConfig
	Log   logx.LogxConfig
	Mysql mysqlxconfig.Mysql
	Jwt   jwtconfig.JwtConfig
	Redis redisconfig.RedisConfig
	Prom  PromCfg
    Trace Trace
}

//promethus 配置
type PromCfg struct {
    Enable bool
	UserName string
	Password string
}

//app
type App struct {
	Name string
	Password string
}


//trace
type Trace struct {
	Enable   bool
	Endpoint string
	UrlPath  string
	Auth     string
}