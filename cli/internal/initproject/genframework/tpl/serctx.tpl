package serctx

import (
	"{{.Module}}/internal/config"
	"gs/pkg/logx"
	"gs/pkg/mysqlx"
	errs "github.com/pkg/errors"
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
		return nil, errs.WithMessage(err, "err init log")
	} else {
		svc.Log = lg
	}

	//数据库
	db := mysqlx.NewDb(c.Mysql)
	if d, err := db.GetDb(); err != nil {
		return nil, errs.WithMessage(err, "err init db")
	} else {
		svc.Db = d		
	}

	return svc, nil
}