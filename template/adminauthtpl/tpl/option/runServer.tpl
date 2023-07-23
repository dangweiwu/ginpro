package option

import (
	"context"
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/pkg/fullurl"
	"github.com/gin-gonic/gin"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"go.uber.org/zap"
	"{{.Host}}/api/apiserver"
	"{{.Host}}/pkg/tracex"
	"{{.Host}}/pkg/yamconfig"
)

type RunServe struct {
	ApiHost string `long:"apihost" description:"api启动host"`
}

func (this *RunServe) Execute(args []string) error {
	//配置参数
	var c config.Config
	yamconfig.MustLoad(Opt.ConfigPath, &c)

	if Opt.RunServe.ApiHost != "" {
		c.Api.Host = Opt.RunServe.ApiHost
	}
	//资源初始化
	sc, err := ctx.NewServerContext(c)
	if err != nil {
		panic(err)
	}

	//服务 中间件
	//engine := gin.Default()

	engine := gin.New()
	//trace
	if c.Trace.Enable {
		tp := tracex.InitTracerHTTP(c.Trace.Endpoint, c.Trace.UrlPath, c.Trace.Auth, c.App.Name)
		defer func() {
			if err := tp.Shutdown(context.Background()); err != nil {
				sc.Log.Error("Error shutting down tracer provider", zap.Error(err))
			}
		}()
	}

	//启动promagent
	engine.GET("/metrics", gin.BasicAuth(gin.Accounts{c.Prom.UserName: c.Prom.Password}), gin.WrapH(promhttp.Handler()))

	//中间件
	apiserver.RegMiddler(engine,
		apiserver.WithStatic("/view", c.Api.ViewDir),
		apiserver.WithMiddle(middler.RegMiddler(sc)...),
	)

	//注册路由
	app.RegisterRoute(engine, sc)

	//记录路由
	fullurl.NewFullUrl().InitUrl(engine)

	//启动
	apiserver.Run(engine, sc.Log.Logger, c.Api)
	return nil
}
