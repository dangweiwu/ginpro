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
	//usage 自定义
	flag.Usage = func(){
		fmt.Println("{{.Module}} v1.0")
		fmt.Println("main [tag]")
		flag.PrintDefaults()
	}
	var c config.Config
	flag.Parse()
	yamconfig.MustLoad(*configFile, &c)

	//资源初始化
	sc, err := serctx.NewServerContext(c)
	if err != nil {
		panic(err)
	}

	//服务
	server := apiserver.NewApiServer(c.Api, sc.Log.Logger,
		apiserver.WithMiddle(middler.RegMiddler(sc)...),
		apiserver.WithStatic("/view", c.Api.ViewDir),
	)

	//注册路由
	app.RegisterRoute(router.NewRouter(server.GetEngine(), sc), sc)

	//注册数据库
	app.Regdb(sc)

	//启动
	server.Start()
}
