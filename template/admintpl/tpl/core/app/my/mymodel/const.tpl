package mymodel

import (
	"strconv"
)

func GetAdminRedisId(id int) string {
	return strconv.Itoa(id)
}

// redis login id
func GetAdminRedisLoginId(appName string, id int) string {
	return appName + "lgn:" + GetAdminRedisId(id)
}

// redis login refreshtoken id
func GetAdminRedisRefreshTokenId(appName string, id int) string {
	return appName + "rft:" + GetAdminRedisId(id)
}
