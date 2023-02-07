package option

import (
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/middler"
	"{{.Module}}/internal/pkg/fullurl"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/apiserver"
	"{{.Host}}/pkg/metric"
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
