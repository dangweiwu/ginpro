package logx

import (
	"fmt"
	"testing"

	"go.uber.org/zap"
)

func TestLog(t *testing.T) {
	cfg := LogxConfig{}
	cfg.HasTimestamp = true
	cfg.LogName = "api.log"
	cfg.OutType = "console"
	lg, error := NewLogx(cfg)
	fmt.Println(error)
	lg.Info("this is test", zap.String("name", "1000"))
}
