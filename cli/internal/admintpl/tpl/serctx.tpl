package serctx

import (
	"{{.Module}}/internal/config"
	"gs/pkg/logx"
	"gs/pkg/mysqlx"
	"gs/pkg/redisx"
	"github.com/go-redis/redis"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
)

//所有资源放在此处
type ServerContext struct {
	Config config.Config
	Log    *logx.Logx
	Db     *gorm.DB
	Redis  *redis.Client
}

func NewServerContext(c config.Config) (*ServerContext, error) {
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
		d.Debug()
		sc.Db = d
		sc.Log.Info("数据库初始化完成")

	}

	//初始化redis
	if redisCli, err := redisx.NewRedis(c.Redis).GetDb(); err != nil {
		return nil, errs.WithMessage(err, "err init redis")
	} else {
		sc.Redis = redisCli
		sc.Log.Info("redis初始化完成")

	}

	return sc, nil
}
