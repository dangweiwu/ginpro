package adminlogin_test

import (
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/apptest/adminmock"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/pkg/jwtx/jwtconfig"
	"{{.Module}}/internal/serctx"
	mredis "github.com/alicebob/miniredis/v2"
	"github.com/gin-gonic/gin"
	"gs/api/apiserver"
	"gs/pkg/mysqlx/mysqlfake"
	"gs/pkg/mysqlx/mysqlxconfig"
	"gs/pkg/redisx/redisconfig"
	"log"
	"testing"
)

var (
	user     = "admin"
	password = "123456"

	accsessToken = ""
	refleshTime  = int64(0)
	refleshToken = ""

	cfg    config.Config
	engine *gin.Engine
	sc     *serctx.ServerContext
)

func initcfg() {
	//1. 配置文件进行
	cfg = config.Config{}

	cfg.Mysql = mysqlxconfig.Mysql{}
	cfg.Mysql.Host = "localhost:13313"
	cfg.Mysql.DbName = "demo1"
	cfg.Mysql.LogLevel = 1
	cfg.Mysql.User = "root"
	cfg.Mysql.Password = "123456"

	cfg.Redis = redisconfig.RedisConfig{}
	cfg.Redis.Db = 0

	cfg.Jwt = jwtconfig.JwtConfig{}
	cfg.Jwt.Secret = ""
	cfg.Jwt.Exp = 1000

}

func initweb() {
	gin.SetMode(gin.ReleaseMode)
	engine = gin.New()
	_sc, err := serctx.NewServerContext(cfg)
	if err != nil {
		panic(err)
	}
	sc = _sc

	//服务 中间件
	apiserver.RegMiddler(engine,
		apiserver.WithMiddle(middler.RegMiddler(sc)...),
	)
	//注册路由
	app.RegisterRoute(engine, sc)

	//注册数据库
	app.Regdb(sc)
}

func TestMain(m *testing.M) {

	initcfg()

	//2. fake服务
	//fake mysql
	//fmt.Println("@@", cfg.Mysql.Host)
	dbserve := mysqlfake.FakeMysql(cfg.Mysql.Host, cfg.Mysql.DbName)

	//fake redis
	r, err := mredis.Run()
	if err != nil {
		panic(err)
	}
	cfg.Redis.Addr = r.Addr()

	//web
	initweb()

	//mock data
	//mock用户
	adminmock.MockMysqlSuperAdmin(sc.Db, user, password)

	log.Println("admin finish init")
	m.Run()
	log.Println("admin test over")
	dbserve.Close()
}

func TestLogin(t *testing.T) {
	t.Run("login", login)
	t.Run("reflesh", refreshTokenf)
	t.Run("logout", logout)
}