package config

import (
	"{{.Module}}/internal/app/admin/adminconfig"
	"{{.Module}}/internal/pkg/jwtx/jwtconfig"
	"gs/api/apiserver/apiconfig"
	"gs/pkg/logx"
	"gs/pkg/mysqlx/mysqlxconfig"
	"gs/pkg/redisx/redisconfig"
)

//全局配置文件
type Config struct {
	Api   apiconfig.ApiConfig
	Admin adminconfig.AdminConfig
	Log   logx.LogxConfig
	Mysql mysqlxconfig.Mysql
	Jwt   jwtconfig.JwtConfig
	Redis redisconfig.RedisConfig
}
