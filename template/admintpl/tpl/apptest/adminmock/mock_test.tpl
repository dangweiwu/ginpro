package adminmock

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx/jwtconfig"
	"{{.Module}}/internal/serctx"
	"fmt"
	mredis "github.com/alicebob/miniredis/v2"
	"github.com/stretchr/testify/assert"
	"gs/pkg/mysqlx"
	"gs/pkg/mysqlx/initmysqlfake"
	"gs/pkg/mysqlx/mysqlxconfig"
	"gs/pkg/redisx/redisconfig"
	"log"
	"testing"

	"gorm.io/gorm"
)

var (
	host     = "localhost:3308"
	dbName   = "demo"
	user     = "admin"
	password = "123456"
	redisadd = ""

	cfg config.Config

	sc *serctx.ServerContext
)

func TestMain(m *testing.M) {

	s, db := initmysqlfake.InitFakeDb(host, dbName, "", 2)
	err := db.AutoMigrate(&adminmodel.AdminPo{})
	if err != nil {
		panic(err)
	}
	r, err := mredis.Run()
	if err != nil {
		panic(err)
	}
	redisadd = r.Addr()

	cfg = config.Config{}
	cfg.Redis = redisconfig.RedisConfig{}
	cfg.Redis.Addr = redisadd

	cfg.Mysql = mysqlxconfig.Mysql{}
	cfg.Mysql.DbName = dbName
	cfg.Mysql.Host = host

	cfg.Jwt = jwtconfig.JwtConfig{}
	cfg.Jwt.Exp = 1000
	sc, _ = serctx.NewServerContext(cfg)
	log.Println("admin mock finish init")
	m.Run()
	log.Println("admin mock test over")
	s()
}

func TestMockMysqlSuperAdmin(t *testing.T) {
	db := mysqlx.GetDb()
	if db == nil {
		panic("get db is nil")
	}
	type args struct {
		db       *gorm.DB
		account  string
		password string
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
	}{
		{
			"createSuperMan",
			args{
				db,
				user,
				password,
			},
			false,
		},
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if err := MockMysqlSuperAdmin(tt.args.db, tt.args.account, tt.args.password); (err != nil) != tt.wantErr {
				t.Errorf("MockMysqlSuperAdmin() error = %v, wantErr %v", err, tt.wantErr)
			}
			po := adminmodel.AdminPo{}
			r := db.Where("account=?", user).Take(&po)
			assert.Nil(t, r.Error)
			assert.Equal(t, po.Password, pkg.GetPassword(password))
		})
	}
}

func TestMockLogin(t *testing.T) {

	type args struct {
		dbname   string
		user     string
		password string
	}
	tests := []struct {
		name    string
		args    args
		want    *LoginData
		wantErr bool
	}{
		{
			name: "login",
			args: args{
				dbName, user, password,
			},
			want:    &LoginData{},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := MockLogin(sc, tt.args.user, tt.args.password)
			assert.Nil(t, err)
			fmt.Println("got", got)
			assert.NotEmptyf(t, got.AccessToken, "accessToken")
			assert.NotEmptyf(t, got.RefreshToken, "refleshToken")
			assert.NotEmptyf(t, got.RefreshAt, "freshtime")
			return

		})
	}
}