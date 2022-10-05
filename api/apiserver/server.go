package apiserver

import (
	"context"
	"gs/api/apiserver/apiconfig"
	"io/ioutil"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type ApiServer struct {
	app        *gin.Engine
	cfg        apiconfig.ApiConfig
	log        *zap.Logger
	closeEvent map[string]func() error
}

func NewApiServer(app *gin.Engine, cfg apiconfig.ApiConfig, lg *zap.Logger, opt ...ApiOpt) *ApiServer {

	if !cfg.OpenGinLog {
		gin.DefaultWriter = ioutil.Discard
		gin.SetMode(gin.ReleaseMode)
	}
	bootlog := lg.With(zap.String("kind", "boot"))
	bootlog.Info("api服务启动")

	ser := &ApiServer{app: app, cfg: cfg, log: bootlog}

	for _, v := range opt {
		v(ser)
	}

	return ser
}

func (this *ApiServer) GetEngine() *gin.Engine {
	return this.app
}

func (this *ApiServer) Start() {
	go func() {
		if this.log != nil {
			this.log.Info("Listening and serving HTTP on " + this.cfg.Host)
		}
		err := this.app.Run(this.cfg.Host)
		if err != nil {
			panic(err)
		}
	}()

	quit := make(chan os.Signal)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
	defer cancel()
	for k, v := range this.closeEvent {
		err := v()
		if this.log != nil {
			if err == nil {
				this.log.Info("安全结束", zap.String("name", k))
			} else {
				this.log.Error("结束异常", zap.String("name", k), zap.Error(err))
			}
		}
	}

	//安全结束的程序
	// 5 秒后捕获 ctx.Done() 信号
	select {
	case <-ctx.Done():
	}
}
