package main

import (
	"flag"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/router"
	"gs/pkg/yamconfig"
	"gs/api/apiserver"
)

var configFile = flag.String("f", "./config/config.yaml", "the config file")

func main() {
	var c config.Config
	flag.Parse()
	yamconfig.MustLoad(*configFile, &c)

	//资源初始化
	ctx, err := serctx.NewServerContext(c)
	if err != nil {
		panic(err)
	}

	//服务 NewApiServer 可用配置
	server := apiserver.NewApiServer(c.Api, ctx.Log.Logger,
		apiserver.WithStatic("/view", c.Api.StaticDir),
	)

	//注册路由
	app.RegisterRoute(router.NewRouter(server.GetEngine(), ctx), ctx)

	//注册数据库
	app.Regdb(ctx)

	//启动
	server.Start()
}