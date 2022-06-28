package mysqlx

import (
	"fmt"
	"gs/pkg/mysqlx/mysqlxconfig"
	"sync"

	"gorm.io/driver/mysql"

	"gorm.io/gorm"
)

var _db *gorm.DB
var once sync.Once

type Mysqlx struct {
	cfg mysqlxconfig.Mysql
}

func NewDb(cfg mysqlxconfig.Mysql) *Mysqlx {
	return &Mysqlx{cfg}
}

func (this *Mysqlx) GetDb() (db *gorm.DB, err error) {
	if _db == nil {
		once.Do(func() {
			dsn := "%s:%s@tcp(%s)/%s?charset=utf8mb4&parseTime=True&loc=Local"
			dbcfg := &gorm.Config{
				DisableForeignKeyConstraintWhenMigrating: true,
			}
			db, err = gorm.Open(mysql.Open(fmt.Sprintf(dsn, this.cfg.User, this.cfg.Password, this.cfg.Host, this.cfg.DbName)), dbcfg)
		})
		return
	} else {
		return _db, nil
	}
}

func (this *Mysqlx) HideLog() {
	if _db == nil {
		_db.Logger = nil
	}
}
