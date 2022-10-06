package cmd

import (
	"{{.Module}}/internal/app/admin/adminconfig"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/pkg"
	"github.com/stretchr/testify/assert"
	"gorm.io/gorm"
	"gs/pkg/mysqlx"
	"gs/pkg/mysqlx/initmysqlfake"
	"gs/pkg/mysqlx/mysqlxconfig"
	"log"
	"testing"
)

var host = "localhost:11000"
var dbName = "demo"

func TestMain(m *testing.M) {
	s, db := initmysqlfake.InitFakeDb(host, dbName, "", 4)
	if db == nil {
		panic("gorm.db is nil")
	}
	if err := db.AutoMigrate(&adminmodel.AdminPo{}); err != nil {
		panic(err)
	}
	log.Println("数据库初始化完毕")
	m.Run()
	log.Println("测试运行完毕")
	s()
}

func TestSuperman_CreateSuperman(t *testing.T) {
	db, err := mysqlx.NewDb(mysqlxconfig.Mysql{}).GetDb()

	if err != nil {
		panic(err)
	}
	type fields struct {
		db  *gorm.DB
		cfg config.Config
	}
	tests := []struct {
		name   string
		fields fields
	}{
		{
			"create_super_account",
			fields{
				db,
				config.Config{
					Admin: adminconfig.AdminConfig{InitAdmin: true, RawPassword: "123456"},
					Mysql: mysqlxconfig.Mysql{Password: "xxx", User: "root", Host: host, DbName: dbName},
				},
			},
		},
		{
			"update_super_account_password",
			fields{
				db,
				config.Config{
					Admin: adminconfig.AdminConfig{InitAdmin: true, RawPassword: "abcd"},
					Mysql: mysqlxconfig.Mysql{Password: "xxx", User: "root", Host: host, DbName: dbName},
				},
			},
		},
		{
			"forbit_create_or_update_super_account",
			fields{
				db,
				config.Config{
					Admin: adminconfig.AdminConfig{InitAdmin: false, RawPassword: "123456"},
					Mysql: mysqlxconfig.Mysql{Password: "xxx", User: "root", Host: host, DbName: dbName},
				},
			},
		},
	}
	for k, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			this := &Superman{
				db:  tt.fields.db,
				cfg: tt.fields.cfg,
			}
			err := this.CreateSuperman()

			switch k {
			case 0:
				assert.Nil(t, err, "测试失败")
				rpo := &adminmodel.AdminPo{}
				r := db.Where("account=?", "admin").Take(rpo)
				assert.Nil(t, r.Error, "获取用户失败")
				assert.Equal(t, rpo.Account, "admin", "创建用户名账号不相符")
				assert.Equal(t, pkg.GetPassword("123456"), rpo.Password, "创建用户密码不相符")
			case 1:
				assert.Nil(t, err, "测试失败")
				rpo := &adminmodel.AdminPo{}
				r := db.Where("account=?", "admin").Take(rpo)
				assert.Nil(t, r.Error, "获取用户失败")
				assert.Equal(t, rpo.Account, "admin", "创建用户名账号不相符")
				assert.Equal(t, pkg.GetPassword("abcd"), rpo.Password, "更新账号失败")
			case 2:
				if assert.Error(t, err) {
					assert.Contains(t, err.Error(), "forbit")
				}
			}

		})
	}
}
