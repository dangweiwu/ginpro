package testtool

import (
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/pkg/jwtx/jwtconfig"
	"{{.Host}}/pkg/logx"
	"{{.Host}}/pkg/mysqlx/mysqlxconfig"
	"{{.Host}}/pkg/redisx/redisconfig"
)

func NewTestConfig() config.Config {
	a := config.Config{}
	a.App = config.App{"test"}
	a.Log = logx.LogxConfig{Level: "error", OutType: "console", Formatter: "json"}
	a.Redis = redisconfig.RedisConfig{}
	a.Mysql = mysqlxconfig.Mysql{Host: "localhost:4417", DbName: "test"}
	a.Jwt = jwtconfig.JwtConfig{"123", int64(5)}
	return a
}
