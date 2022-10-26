package adminmock

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/admin/handler"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/serctx"
	"encoding/json"
	"gorm.io/gorm"
)

/*
创建管理员
*/

func MockMysqlSuperAdmin(db *gorm.DB, account, password string) error {
	po := &adminmodel.AdminPo{}
	po.Account = account
	po.Password = pkg.GetPassword(password)
	po.IsSuperAdmin = "1"
	r := db.Create(po)
	return r.Error
}

type ILogin interface {
	Login(form *handler.LoginForm) (interface{}, error)
}

type LoginData struct {
	AccessToken  string
	RefreshAt        int64
	RefreshToken string
}

func MockLogin(ctx *serctx.ServerContext, user, password string) (*LoginData, error) {
	hd := handler.NewAdminLogin(nil, ctx)
	logform := handler.LoginForm{user, password}
	r, err := hd.(ILogin).Login(&logform)
	if err != nil {
		return nil, err
	}

	bts, err := json.Marshal(r)
	if err != nil {
		return nil, err
	}
	rd := &LoginData{}
	json.Unmarshal(bts, rd)
	return rd, nil
}
