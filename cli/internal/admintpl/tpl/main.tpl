package main

import (
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/router"
	"{{.Module}}/internal/serctx"
	"flag"
	"gs/api/apiserver"
	"gs/pkg/yamconfig"
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

	//服务
	server := apiserver.NewApiServer(c.Api, ctx.Log.Logger,
		apiserver.WithMiddle(middler.RegMiddler(ctx)...),
	)

	//注册路由
	app.RegisterRoute(router.NewRouter(server.GetEngine(), ctx), ctx)

	//注册数据库
	app.Regdb(ctx)

	//启动
	server.Start()
}
