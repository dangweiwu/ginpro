package cmd

import (
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/serctx"
	"github.com/gin-gonic/gin"
	"gs/api/apiserver"
)

func Server(c config.Config) {
	//资源初始化
	sc, err := serctx.NewServerContext(c)
	if err != nil {
		panic(err)
	}
	sc = sc
	//服务 中间件
    engine := gin.New()

	apiserver.RegMiddler(engine,
		apiserver.WithMiddle(middler.RegMiddler(sc)...),
		apiserver.WithStatic("/view", c.Api.ViewDir),
	)
	//注册路由
	app.RegisterRoute(engine, sc)

	//注册数据库
	app.Regdb(sc)

	//启动
	apiserver.Run(engine, sc.Log.Logger, c.Api)
}
