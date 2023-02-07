package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestLogin(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	user := &adminmodel.AdminPo{
		Account:      "admin",
		Password:     pkg.GetPassword("123456"),
		IsSuperAdmin: "1",
		Status:       "1",
	}

	SerCtx.Db.Create(user)

	form := &mymodel.LoginForm{"admin", "123456"}
	bts, _ := json.Marshal(form)

	//正常登陆
	ser := testtool.NewTestServer(SerCtx, "POST", "/api/login", bytes.NewReader(bts)).Do()
	rep := &mymodel.LogRep{}
	json.Unmarshal([]byte(ser.GetBody()), rep)
	firstAccountToken := rep.AccessToken

	if assert.Equal(t, ser.GetCode(), 200, "login:%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.NotEmpty(t, rep.AccessToken)
		assert.NotEmpty(t, rep.RefreshAt)
		assert.NotEmpty(t, rep.RefreshToken)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my", nil).SetAuth(rep.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "my:info:%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "admin")
	}

	//code失效校验
	ser = testtool.NewTestServer(SerCtx, "POST", "/api/login", bytes.NewReader(bts)).Do()
	rep = &mymodel.LogRep{}
	json.Unmarshal([]byte(ser.GetBody()), rep)
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my", nil).SetAuth(firstAccountToken).Do()
	assert.Equal(t, ser.GetCode(), 401, "my:info:%d:%s", ser.GetCode(), ser.GetBody())

	//token 过期校验
	SerCtx.Config.Jwt.Exp = -20
	ser = testtool.NewTestServer(SerCtx, "POST", "/api/login", bytes.NewReader(bts)).Do()
	rep = &mymodel.LogRep{}
	json.Unmarshal([]byte(ser.GetBody()), rep)
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my", nil).SetAuth(rep.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 401, "my:info:%d:%s", ser.GetCode(), ser.GetBody())

	//密码错误
	form = &mymodel.LoginForm{"admin", "123455"}
	bts, _ = json.Marshal(form)
	SerCtx.Config.Jwt.Exp = 100
	ser = testtool.NewTestServer(SerCtx, "POST", "/api/login", bytes.NewReader(bts)).Do()
	//fmt.Print(ser.GetBody())
	if assert.Equal(t, ser.GetCode(), 400, "login:%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "密码错误")
	}
}
