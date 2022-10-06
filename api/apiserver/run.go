package apiserver

import (
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gs/api/apiserver/apiconfig"
	"os"
	"os/signal"
	"syscall"
)

/*
阻塞启动
*/
var quit = make(chan os.Signal)

func Run(engine *gin.Engine, log *zap.Logger, cfg apiconfig.ApiConfig) {
	go func() {
		if log != nil {
			log.Info("Listening and serving HTTP on " + cfg.Host)
		}
		if cfg.CertFile != "" && cfg.KeyFile != "" {
			if err := engine.RunTLS(cfg.Host, cfg.CertFile, cfg.KeyFile); err != nil {
				log.Error("启动失败", zap.Error(err))
				panic(err)
			}
		} else {
			if err := engine.Run(cfg.Host); err != nil {
				log.Error("启动失败", zap.Error(err))
				panic(err)
			}

		}
	}()

	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
}

func Stop() {
	quit <- syscall.SIGINT
}
