package ctx

import (
	"{{.Module}}/internal/config"
	"{{.Host}}/pkg/logx"
	errs "github.com/pkg/errors"
)

//所有资源放在此处
type ServerContext struct {
	Config config.Config
	Log    *logx.Logx
}

func NewServerContext(c config.Config) (*ServerContext, error) {
	//初始化日志
	svc := &ServerContext{}
	svc.Config = c
	if lg, err := logx.NewLogx(c.Log); err != nil {
		return nil, errs.WithMessage(err, "err init log")
	} else {
		svc.Log = lg
	}

	return svc, nil
}