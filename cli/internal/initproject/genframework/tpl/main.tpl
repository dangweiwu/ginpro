package main

import (
	"flag"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/serctx"
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/router"
	"gs/pkg/yamconfig"
	"gs/api/apiserver"
	"gs/pkg/logx"
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
	// apiserver.WithMiddle(),// 中间件
	// apiserver.WithStatic(),//静态资源
	// apiserver.WithStopEvent(), //结束事件
	server := apiserver.NewApiServer(c.Api, ctx.Log.Logger)

	//注册路由
	app.RegisterRoute(router.NewRouter(server.GetEngine(), ctx), ctx)

	//注册数据库
	app.Regdb(ctx)

	//启动
	server.Start()
}