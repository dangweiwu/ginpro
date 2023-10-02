package mysqlx

import (
	"github.com/stretchr/testify/assert"
	"gorm.io/gorm"
	"github.com/dangweiwu/ginpro/pkg/mysqlx/initmysqlfake"
	"log"
	"testing"
)

func TestMain(m *testing.M) {
	host := "localhost:3308"
	dbName := "demo"
	s, db := initmysqlfake.InitFakeDb(host, dbName, "", 2)
	err := db.AutoMigrate(&Demo{})
	if err != nil {
		panic(err)

	}

	log.Println("数据库初始化完毕")
	m.Run()
	log.Println("测试运行完毕")
	s()
}

type Demo struct {
	gorm.Model
	Name string
	Num  int
}

func TestFakeMysql(t *testing.T) {
	db := GetDb()
	assert.NotNil(t, db, "获取数据库失败")

	//2. insert
	demo := Demo{}
	demo.Name = "demo"
	demo.Num = 123

	//
	r := db.Create(&demo)
	assert.Nil(t, r.Error, "创建数据失败")

	r = db.Updates(demo)
	assert.Nil(t, r.Error, "创建数据失败")

	rd := Demo{}
	r = db.Where("name = ?", "demo").Take(&rd)
	assert.Nil(t, r.Error, "获取数据失败")
	assert.Equal(t, rd.Name, demo.Name)
	assert.Equal(t, rd.Num, demo.Num)
	assert.NotEqual(t, rd.UpdatedAt, demo.UpdatedAt)
}
