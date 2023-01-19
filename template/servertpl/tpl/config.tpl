package config

import (
	"gs/api/apiserver/apiconfig"
	"gs/pkg/logx"
	"gs/pkg/mysqlx/mysqlxconfig"
)

//全局配置文件
type Config struct {
	Api apiconfig.ApiConfig
	Log logx.LogxConfig
	Mysql mysqlxconfig.Mysql
}
