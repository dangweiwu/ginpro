package initmysqlfake

import (
	"gorm.io/gorm"
	"gs/pkg/mysqlx"
	"gs/pkg/mysqlx/mysqlfake"
	"gs/pkg/mysqlx/mysqlxconfig"
)

func InitFakeDb(host, dbName string, logpath string, loglevel int) (func() error, *gorm.DB) {
	s := mysqlfake.FakeMysql(host, dbName)
	cfg := mysqlxconfig.Mysql{
		User:     "root",
		Password: "root",
		Host:     host,
		DbName:   dbName,
		LogLevel: loglevel,
		LogFile:  logpath,
	}
	db, err := mysqlx.NewDb(cfg).GetDb()
	if err != nil {
		panic(err)
	}
	var f = s.Close
	return f, db
}
