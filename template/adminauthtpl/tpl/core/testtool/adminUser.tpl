package testtool

import (
	"context"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/testtool/testctx"
	"errors"
	"github.com/google/uuid"
	"gorm.io/gorm"
	"strings"
	"time"
)

// 数据库创建用户
type MockUser struct {
	Po           *adminmodel.AdminPo
	Account      string
	Password     string
	IsSuper      string
	LoginCode    string
	AccessToken  string `json:"access_token"`
	RefreshAt    int64  `json:"refresh_at"`
	RefreshToken string `json:"refresh_token"`

	Ctx *testctx.TestContext

	Err error
}

func NewMockUser(ctx *testctx.TestContext) *MockUser {
	return &MockUser{Ctx: ctx}
}

// 数据库增加人员数据
func (this *MockUser) Create(account, password, issuper, role, phone string) *MockUser {
	if this.Err != nil {
		return this
	}
	po := &adminmodel.AdminPo{}
	po.Account = account
	po.Password = pkg.GetPassword(password)
	po.IsSuperAdmin = issuper
	po.Phone = phone
	po.Role = role
	r := this.Ctx.Db.Create(po)
	if r.Error != nil {
		this.Err = r.Error
		return this
	}
	this.Account = account
	this.Password = password
	this.IsSuper = issuper
	if r.Error != nil {
		this.Err = r.Error
		return this
	}
	this.Po = po
	return this
}

func (this *MockUser) Mock() *MockUser {
	if this.Err != nil {
		return this
	}
	po := &adminmodel.AdminPo{}
	po.Account = "admin"
	po.Password = pkg.GetPassword("123456")
	po.IsSuperAdmin = "1"
	//po.Role = ""
	r := this.Ctx.Db.Create(po)

	this.Account = po.Account
	this.Password = "123456"
	this.IsSuper = po.IsSuperAdmin
	if r.Error != nil {
		this.Err = r.Error
		return this
	}
	this.Po = po
	return this
}

// 数据库和缓存增加数据 涉及中间件包括login
func (this *MockUser) Login() *MockUser {
	if this.Err != nil {
		return this
	}
	if err := this.GetUserByAccount(); err != nil {
		this.Err = err
		return this
	}

	now := time.Now().Unix()
	var logincode string
	if logincode = uuid.New().String(); logincode == "" {
		this.Err = errors.New("logincode is empty")
		return this
	}
	logincode = strings.Split(logincode, "-")[0]
	this.LoginCode = logincode

	if token, err := jwtx.GenToken(
		this.Ctx.Config.Jwt.Secret,
		now+this.Ctx.Config.Jwt.Exp,
		now+this.Ctx.Config.Jwt.Exp/2,
		this.Po.ID,
		this.LoginCode,
		this.Po.Role,
		this.Po.IsSuperAdmin,
	); err != nil {
		this.Err = err
		return this
	} else {
		// this.ctx.Header("Authorization", token)
		refleshToken, err := this.SetRefreshToken(this.Po.ID)
		if err != nil {
			panic(err)
		}
		this.AccessToken = token
		this.RefreshAt = now + this.Ctx.Config.Jwt.Exp/2
		this.RefreshToken = refleshToken
		return this
	}
}

func (this *MockUser) GetUserByAccount() error {
	po := &adminmodel.AdminPo{}
	if r := this.Ctx.Db.Model(po).Where("account=?", this.Account).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("账号不存在")
		} else {
			return r.Error
		}
	}
	this.Po = po

	return nil
}

// redis 设置刷新token
func (this *MockUser) SetRefreshToken(id int64) (string, error) {
	var refreshToken string
	if refreshToken = uuid.New().String(); refreshToken == "" {
		return "", errors.New("refreshToken is empty")
	} else {
		refreshToken = strings.Split(refreshToken, "-")[0]
		if r := this.Ctx.Redis.Set(context.Background(), mymodel.GetAdminRedisRefreshTokenId(this.Ctx.Config.App.Name, int(id)), refreshToken, 0); r.Err() != nil {
			return "", r.Err()
		} else {
			return refreshToken, nil
		}
	}
}

// 登陆之后调用
func (this *MockUser) SetLogCode() *MockUser {
	if this.Err != nil {
		return this
	}
	if r := this.Ctx.Redis.Set(context.Background(), mymodel.GetAdminRedisLoginId(this.Ctx.Config.App.Name, int(this.Po.ID)), this.LoginCode, 0); r.Err() != nil {
		this.Err = r.Err()
		return this
	}
	return this
}
