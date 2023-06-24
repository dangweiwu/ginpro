package ctx

import (
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/pkg/lg"
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
		lg.Msg("数据库链接成功").Info(sc.Log)
	}
	return sc, nil
}
