package lg

import (
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"{{.Host}}/pkg/logx"
	"time"
)

/*
es mapping kind=api

	time is iso8601

	{
	  "level":{"type":"keyword"},
	  "time":{"type":"date"},
	  "msg":{"type":"text"},
	  "kind":{"type":"keyword"},
	  "rid":{"type":"keyword"},
	  "path":{"type":"text"},
	  "latency":{"type":"long","index":false},
	  "ip":{"type":"keyword"},
	  "method":{"type":"keyword"},
	  "status":{"type":"long","index":false},
	  "error":{"type":"keyword","index":false},
	  "account":{"type":"keyword"},
	  "stack":{"type":"keyword","index": false},

	  "topic": {"type":"keyword"},
	  "sn": {"type":"keyword"},
	  "data": {"type": "text","index": false},
	  "exdata": {"type": "text"},
	  "saveTime": {"type": "long","index": false}
	}
*/
type Data struct {
	msg  string
	data []zapcore.Field
}

func (this *Data) Do(lg *logx.Logx, level zapcore.Level) {
	this.Time(time.Now())
	lg.Log(level, this.msg, this.data...)
}

func (this *Data) Info(lg *logx.Logx) {
	this.Level("info")
	this.Do(lg, zapcore.InfoLevel)
}

func (this *Data) Err(lg *logx.Logx) {
	this.Level("error")
	this.Do(lg, zapcore.ErrorLevel)
}

func (this *Data) Debug(lg *logx.Logx) {
	this.Level("debug")
	this.Do(lg, zapcore.DebugLevel)
}

func (this *Data) Panic(lg *logx.Logx) {
	this.Level("panic")
	this.Do(lg, zapcore.PanicLevel)
}

func (this *Data) Msg(msg string) *Data {
	this.msg = msg
	return this
}

func (this *Data) Level(level string) *Data {
	this.data = append(this.data, zap.String("level", level))
	return this
}
func (this *Data) Time(tm time.Time) *Data {
	this.data = append(this.data, zap.Time("time", tm))
	return this
}

func (this *Data) Kind(kind string) *Data {
	this.data = append(this.data, zap.String("kind", kind))
	return this
}

// 请求uuid
func (this *Data) Uid(uid string) *Data {
	this.data = append(this.data, zap.String("uuid", uid))
	return this
}

// 数据库ID
func (this *Data) Id(id int64) *Data {
	this.data = append(this.data, zap.Int64("id", id))
	return this
}

func (this *Data) Api(method, path string, status, size, latency int) *Data {
	this.data = append(this.data, zap.String("method", method), zap.String("path", path), zap.Int("status", status), zap.Int("size", size), zap.Int("lat", latency))
	return this
}

func (this *Data) IndexData(data string) *Data {
	this.data = append(this.data, zap.String("data", data))
	return this
}

func (this *Data) ExData(data string) *Data {
	this.data = append(this.data, zap.String("exdata", data))
	return this
}

func (this *Data) SetErr(err error) *Data {
	this.data = append(this.data, zap.Error(err))
	return this
}

func Msg(msg string) *Data {
	return &Data{msg: msg, data: []zapcore.Field{}}
}

