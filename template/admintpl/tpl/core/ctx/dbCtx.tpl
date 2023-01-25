package ctx

import (
	"{{.Module}}/internal/config"
	errs "github.com/pkg/errors"
	"{{.Host}}/pkg/logx"
	"{{.Host}}/pkg/mysqlx"
)

func NewDbContext(c config.Config) (*ServerContext, error) {
	//初始化日志
	sc := &ServerContext{}
	sc.Config = c
	if lg, err := logx.NewLogx(c.Log); err != nil {
		return nil, err
	} else {
		sc.Log = lg
	}

	//初始化数据库
	db := mysqlx.NewDb(c.Mysql)
	if d, err := db.GetDb(); err != nil {
		return nil, errs.WithMessage(err, "err init db")
	} else {
		//d.Debug()
		sc.Db = d
		sc.Log.Info("数据库连接成功")
	}
	return sc, nil
}
