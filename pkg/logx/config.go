package logx

const (
	//level
	ERROR = "error"
	DEBUG = "debug"
	PANIC = "panic"
	INFO  = "info"
	WARN  = "warn"

	//输出类型
	JSON = "json"
	TXT  = "txt"

	//输出位置
	CONSOLE = "console"
	FILE    = "file"
	ALL     = "all"
)

/*
生成log
*/
type LogxConfig struct {
	//分割配置
	LogName      string `default:"log.log"` // 日志文件路径，默认 os.TempDir()
	MaxSize      int    `default:"10"`      // 每个日志文件保存10M，默认 100M
	MaxBackNum   int    `default:"15" `     // 保留30个备份，默认不限
	MaxAge       int    `default:"7"`       // 保留7天，默认不限
	Compress     bool   `default:"false"`   // 是否压缩，默认不压缩
	Level        string `default:"debug" validate:"one_of=error,debug,panic,info,warn"`
	OutType      string `default:"console" validate:"one_of=console,file,all"` // 输出到哪 console all file
	Formatter    string `default:"txt" validate:"one_of=txt,json"`             //json or txt
	HasTimestamp bool   `default:"false"`
	Caller       bool   `default:"false"` //启用堆栈
	Development  bool   `default:"false"` // 记录行号
}

type LogxOpt func(*LogxConfig)

func WithFileName(name string) LogxOpt {
	return func(lc *LogxConfig) {
		lc.LogName = name
	}
}

//设置最大文件尺寸
func WithMaxSize(size int) LogxOpt {
	return func(lc *LogxConfig) {
		lc.MaxSize = size
	}
}

//设置备份数量
func WithBackNum(num int) LogxOpt {
	return func(lc *LogxConfig) {
		lc.MaxBackNum = num
	}
}

//设置保留天数
func WithMaxAge(day int) LogxOpt {
	return func(lc *LogxConfig) {
		lc.MaxAge = day
	}
}

//设置是否压缩
func WithCompress(cpr bool) LogxOpt {
	return func(lc *LogxConfig) {
		lc.Compress = cpr
	}
}

func WithLevel(level string) LogxOpt {
	return func(lc *LogxConfig) {
		lc.Level = level
	}
}

func WithFormatter(formatter string) LogxOpt {
	return func(lc *LogxConfig) {
		lc.Formatter = formatter
	}
}

func WithOutType(tp string) LogxOpt {
	return func(lc *LogxConfig) {
		lc.OutType = tp
	}
}

func WithCaller(has bool) LogxOpt {
	return func(lc *LogxConfig) {
		lc.Caller = has
	}
}

func WithDev(has bool) LogxOpt {
	return func(lc *LogxConfig) {
		lc.Development = has
	}
}
