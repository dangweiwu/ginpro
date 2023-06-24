package option

import (
    "context"
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/pkg/fullurl"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/apiserver"
	"{{.Host}}/pkg/metric"
	"{{.Host}}/pkg/yamconfig"
    "go.opentelemetry.io/contrib/instrumentation/github.com/gin-gonic/gin/otelgin"
    "{{.Module}}/internal/pkg/tel"
    "go.uber.org/zap"
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
        tp := tel.InitTracerHTTP(c.Trace.Endpoint, c.Trace.UrlPath, c.Trace.Auth)
        defer func() {
            if err := tp.Shutdown(context.Background()); err != nil {
                sc.Log.Error("Error shutting down tracer provider", zap.Error(err))
            }
        }()
        engine.Use(otelgin.Middleware("{{.Module}}"))
    }


	//启动promagent
	metric.StartAgent(engine, "/metrics", sc.Config.Prom.UserName, sc.Config.Prom.Password)
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
