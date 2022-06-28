package mysqlxconfig

type Mysql struct {
	User     string `validate:"empty=false"`
	Password string `validate:"empty=false"`
	Host     string `default:"localhost:3306"`
	DbName   string `validate:"empty=false"`
}
