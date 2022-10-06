package mysqlxconfig

type Mysql struct {
	User     string `validate:"empty=false"`
	Password string `validate:"empty=false"`
	Host     string `default:"localhost:3306"`
	DbName   string `validate:"empty=false"`
	LogFile  string //日志位置
	LogLevel int    //1 slice 2 err 3 war 4 info
}
