package serctx

import (
	"{{.Module}}/internal/config"
	"errors"
	"gs/pkg/logx"
	"gs/pkg/mysqlx"

	"gorm.io/gorm"
)

//所有资源放在此处
type ServerContext struct {
	Config config.Config
	Log    *logx.Logx
	Db     *gorm.DB
}

func NewServerContext(c config.Config) (*ServerContext, error) {
	//初始化日志
	svc := &ServerContext{}
	svc.Config = c
	if lg, err := logx.NewLogx(c.Log); err != nil {
		return nil, err
	} else {
		svc.Log = lg
	}

	//数据库
	db := mysqlx.NewDb(c.Mysql)
	if d, err := db.GetDb(); err != nil {
		svc.Db = d
	} else {
		return nil, errors.New("err init db")
	}

	return svc, nil
}