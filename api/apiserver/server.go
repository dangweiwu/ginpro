package apiserver

//type ApiServer struct {
//	App *gin.Engine
//Cfg apiconfig.ApiConfig
//Log *zap.Logger
//closeEvent map[string]func() error
//}

//func NewApiServer(app *gin.Engine, cfg apiconfig.ApiConfig, lg *zap.Logger, opt ...ApiOpt) *ApiServer {
//
//	if !cfg.OpenGinLog {
//		gin.DefaultWriter = ioutil.Discard
//		gin.SetMode(gin.ReleaseMode)
//	}
//	bootlog := lg.With(zap.String("kind", "boot"))
//	bootlog.Info("api服务启动")
//
//	ser := &ApiServer{app: app, cfg: cfg}
//
//	for _, v := range opt {
//		v(ser)
//	}
//
//	return ser
//}
//
//func (this *ApiServer) Start() {
//	go func() {
//		if this.log != nil {
//			this.log.Info("Listening and serving HTTP on " + this.cfg.Host)
//		}
//		err := this.app.Run(this.cfg.Host)
//		if err != nil {
//			panic(err)
//		}
//	}()
//
//	quit := make(chan os.Signal)
//	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
//	<-quit
//	ctx, cancel := context.WithTimeout(context.Background(), time.Second)
//	defer cancel()
//
//	//安全结束的程序
//	// 5 秒后捕获 ctx.Done() 信号
//	select {
//	case <-ctx.Done():
//	}
//}
