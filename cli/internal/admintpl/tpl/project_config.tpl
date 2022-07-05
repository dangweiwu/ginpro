package config

import (
	"{{.Module}}/internal/pkg/jwtx/jwtconfig"
	"gs/api/apiserver/apiconfig"
	"gs/pkg/logx"
	"gs/pkg/mysqlx/mysqlxconfig"
	"gs/pkg/redisx/redisconfig"
)

//全局配置文件
type Config struct {
	Api   apiconfig.ApiConfig
	Log   logx.LogxConfig
	Mysql mysqlxconfig.Mysql
	Jwt   jwtconfig.JwtConfig
	Redis redisconfig.RedisConfig
}
