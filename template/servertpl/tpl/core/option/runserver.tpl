package option

import (
	"{{.Module}}/internal/api"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/ctx"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/apiserver"
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

	//服务
	engine := gin.Default()

	//中间件
    apiserver.RegMiddler(engine, apiserver.WithStatic("/view", c.Api.ViewDir))

	//注册路由
	api.RegisterRoute(engine, sc)

	//启动
	apiserver.Run(engine, sc.Log.Logger, c.Api)
	return nil
}