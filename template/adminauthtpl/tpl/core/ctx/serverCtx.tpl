package ctx

import (
	"{{.Module}}/internal/app/auth/authcheck"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/pkg/lg"
	"github.com/go-redis/redis/v8"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
	"{{.Host}}/pkg/logx"
	"{{.Host}}/pkg/metric"
	"{{.Host}}/pkg/mysqlx"
	"{{.Host}}/pkg/redisx"
	"{{.Host}}/pkg/tracex"
	"time"
)

// 所有资源放在此处
type ServerContext struct {
	StartTime time.Time
	Config    config.Config
	Log       *logx.Logx
	Db        *gorm.DB
	Redis     *redis.Client
	AuthCheck *authcheck.AuthCheck
	Tracer    *tracex.Tracex
}

func NewServerContext(c config.Config) (*ServerContext, error) {
	//初始化日志
	sc := &ServerContext{}
	sc.StartTime = time.Now()
	sc.Tracer = tracex.NewTrace(c.App.Name)
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
		lg.Msg("数据库链接成功").Info(sc.Log)
	}

	//初始化redis
	if redisCli, err := redisx.NewRedis(c.Redis).GetDb(); err != nil {
		return nil, errs.WithMessage(err, "err init redis")
	} else {
		sc.Redis = redisCli
		lg.Msg("redis链接成功").Info(sc.Log)
	}

	//初始化权限
	if ck, err := authcheck.NewAuthCheckout(sc.Db); err != nil {
		return nil, err
	} else {
		sc.AuthCheck = ck
		lg.Msg("casbin初始化完毕")
	}

	//追踪启动
	if c.Trace.Enable {
		sc.Tracer.SetEnable(true)
	} else {
		sc.Tracer.SetEnable(false)
	}

	//指标采集启动
	if c.Prom.Enable {
		metric.SetEnable(true)
	} else {
		metric.SetEnable(false)
	}

	return sc, nil
}
