package logx

import (
	"os"
	"time"

	"github.com/creasty/defaults"
	"github.com/natefinch/lumberjack"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/dealancer/validate.v2"
)

type Logx struct {
	*zap.Logger
	cfg LogxConfig
}

func NewLogx(cfg LogxConfig) (*Logx, error) {
	if err := defaults.Set(&cfg); err != nil {
		return nil, err
	}
	if err := validate.Validate(&cfg); err != nil {
		return nil, err
	}
	a := &Logx{cfg: cfg}
	encoder := a.setEncode()
	write := a.setWriteSynce()
	level := a.setLevel()

	core := zapcore.NewCore(encoder, write, level)

	ops := []zap.Option{}
	if cfg.Caller {
		ops = append(ops, zap.AddCaller())
	}
	if cfg.Development {
		ops = append(ops, zap.Development())
	}
	a.Logger = zap.New(core, ops...)
	return a, nil
}

//解析器
func (this *Logx) setEncode() zapcore.Encoder {
	encoderConfig := zapcore.EncoderConfig{
		TimeKey:       "time",
		LevelKey:      "level",
		NameKey:       "logger",
		CallerKey:     "linenum",
		MessageKey:    "msg",
		StacktraceKey: "stacktrace",
		LineEnding:    zapcore.DefaultLineEnding,
		EncodeLevel:   zapcore.LowercaseLevelEncoder, // 小写编码器
		// EncodeLevel: zapcore.LowercaseColorLevelEncoder, // 小写编码器
		EncodeTime:     zapcore.ISO8601TimeEncoder,     // ISO8601 UTC 时间格式
		EncodeDuration: zapcore.SecondsDurationEncoder, //
		EncodeCaller:   zapcore.FullCallerEncoder,      // 全路径编码器
		EncodeName:     zapcore.FullNameEncoder,
	}
	if this.cfg.HasTimestamp {
		encoderConfig.EncodeTime = func(t time.Time, enc zapcore.PrimitiveArrayEncoder) {
			// nanos := t.Unix()
			// sec := float64(nanos) / float64(time.Second)
			enc.AppendInt(int(t.UnixMilli()))
		}
	}
	if this.cfg.Formatter == JSON {
		return zapcore.NewJSONEncoder(encoderConfig)
	} else {
		return zapcore.NewConsoleEncoder(encoderConfig)
	}
}

//输出
func (this *Logx) setWriteSynce() (write zapcore.WriteSyncer) {
	var hook lumberjack.Logger
	if this.cfg.OutType == FILE || this.cfg.OutType == ALL {

		hook = lumberjack.Logger{
			Filename:   this.cfg.LogName,    // 日志文件路径，默认 os.TempDir()
			MaxSize:    this.cfg.MaxSize,    // 每个日志文件保存10M，默认 100M
			MaxBackups: this.cfg.MaxBackNum, // 保留30个备份，默认不限
			MaxAge:     this.cfg.MaxAge,     // 保留7天，默认不限
			Compress:   this.cfg.Compress,   // 是否压缩，默认不压缩
		}
	}

	switch this.cfg.OutType {
	case CONSOLE, "":
		write = zapcore.AddSync(os.Stdout)
	case FILE:
		write = zapcore.AddSync(&hook)
	case ALL:
		write = zapcore.NewMultiWriteSyncer(zapcore.AddSync(os.Stdout), zapcore.AddSync(&hook))
	}
	return
}

//类型
func (this *Logx) setLevel() (level zapcore.Level) {
	switch this.cfg.Level {
	case "info":
		level = zapcore.InfoLevel
	case "debug":
		level = zapcore.DebugLevel
	case "warn":
		level = zapcore.WarnLevel
	case "Error":
		level = zapcore.ErrorLevel
	case "panic": //会跳出来
		level = zapcore.DPanicLevel
	default:
		level = zapcore.DebugLevel
	}
	return
}
