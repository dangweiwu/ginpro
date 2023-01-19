package mysqlx

import (
	"fmt"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gs/pkg/mysqlx/mysqlxconfig"
	"io"
	"log"
	"os"
	"sync"
	"time"
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
	//println("-----", this.cfg.LogLevel)
	if _db == nil {
		once.Do(func() {
			dsn := "%s:%s@tcp(%s)/%s?charset=utf8mb4&parseTime=True&loc=Local"
			var out io.Writer
			if len(this.cfg.LogFile) != 0 {
				file, err := os.OpenFile(this.cfg.LogFile,
					os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0660)
				if err != nil {
					panic(err)
				}
				out = io.MultiWriter(file, os.Stdout)
			} else {
				out = os.Stdout
			}

			dbcfg := &gorm.Config{
				DisableForeignKeyConstraintWhenMigrating: true,
				Logger: logger.New(log.New(out, "\r\n", log.LstdFlags), // io writer（日志输出的目标，前缀和日志包含的内容）
					logger.Config{
						SlowThreshold:             time.Second,                        // 慢 SQL 阈值
						LogLevel:                  logger.LogLevel(this.cfg.LogLevel), // 日志级别
						IgnoreRecordNotFoundError: false,                              // 忽略ErrRecordNotFound（记录未找到）错误
						Colorful:                  false,                              // 禁用彩色打印
					}),
			}
			db, err = gorm.Open(mysql.Open(fmt.Sprintf(dsn, this.cfg.User, this.cfg.Password, this.cfg.Host, this.cfg.DbName)), dbcfg)
			_db = db
		})
		return
	} else {
		return _db, nil
	}
}

func GetDb() *gorm.DB {
	return _db
}
