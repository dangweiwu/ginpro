package testctx

import (
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/app/auth/authcheck"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/pkg/lg"
	mredis "github.com/alicebob/miniredis/v2"
	"github.com/dolthub/go-mysql-server/server"
	"github.com/go-redis/redis/v8"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
	"{{.Host}}/pkg/logx"
	"{{.Host}}/pkg/mysqlx"
	"{{.Host}}/pkg/mysqlx/mysqlfake"
	"{{.Host}}/pkg/redisx"
)

type TestContext struct {
	Db       *gorm.DB
	Redis    *redis.Client
	Config   config.Config
	DbSer    *server.Server
	RedisSer *mredis.Miniredis
	ctx      *ctx.ServerContext
}

func NewTestContext(cfg config.Config) (*TestContext, error) {
	a := &TestContext{}
	a.Config = cfg
	a.DbSer = mysqlfake.FakeMysql(a.Config.Mysql.Host, a.Config.Mysql.DbName)
	mr, err := mredis.Run()
	if err != nil {
		return nil, err
	}
	a.RedisSer = mr

	//初始化数据库
	db := mysqlx.NewDb(cfg.Mysql)
	if d, err := db.GetDb(); err != nil {
		return nil, errs.WithMessage(err, "err init db")
	} else {
		a.Db = d
	}

	//初始化redis
	cfg.Redis.Addr = mr.Addr()
	if redisCli, err := redisx.NewRedis(cfg.Redis).GetDb(); err != nil {
		return nil, errs.WithMessage(err, "err init redis")

	} else {
		a.Redis = redisCli
	}

	return a, nil
}

func (this *TestContext) GetServerCtx() (*ctx.ServerContext, error) {
	a := &ctx.ServerContext{}
	if lg, err := logx.NewLogx(this.Config.Log); err != nil {
		return nil, err
	} else {
		a.Log = lg
	}
	a.Config = this.Config
	a.Db = this.Db
	a.Redis = this.Redis

	//注册数据库
	app.Regdb(a)
	this.ctx = a
	return a, nil
}

func (this *TestContext) InitChecAuth() error {
	//初始化权限
	if ck, err := authcheck.NewAuthCheckout(this.Db); err != nil {
		return err
	} else {
		this.ctx.AuthCheck = ck
		lg.Msg("casbin初始化完毕")
	}
	return nil
}

func (this *TestContext) Close() {
	this.DbSer.Close()
	this.RedisSer.Close()
}
