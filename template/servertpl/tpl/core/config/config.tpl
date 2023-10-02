package config

import (
	"{{.Host}}/api/apiserver/apiconfig"
	"{{.Host}}/pkg/logx"
)

//全局配置文件
type Config struct {
	Api apiconfig.ApiConfig
	Log logx.LogxConfig
}
