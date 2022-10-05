package mysqlx

/*
fake mysql数据库
*/

import (
	sqle "github.com/dolthub/go-mysql-server"
	"github.com/dolthub/go-mysql-server/memory"
	"github.com/dolthub/go-mysql-server/server"
	"github.com/dolthub/go-mysql-server/sql"
	"github.com/dolthub/go-mysql-server/sql/information_schema"
)

func FakeMysql(host, dbName string) *server.Server {
	engine := sqle.NewDefault(
		sql.NewDatabaseProvider(
			memory.NewDatabase(dbName),
			information_schema.NewInformationSchemaDatabase(),
		))
	config := server.Config{
		Protocol: "tcp",
		Address:  host,
	}
	s, err := server.NewDefaultServer(config, engine)
	if err != nil {
		panic(err)
	}
	go s.Start()

	return s

}
