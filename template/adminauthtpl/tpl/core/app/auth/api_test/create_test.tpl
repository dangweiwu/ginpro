package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAuthCreate(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + authmodel.AuthPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	form := &authmodel.AuthForm{
		Name: "创建权限", Code: "CreateAuth", OrderNum: 1001, Api: "/api/auth", Method: "POST", Kind: "0"}
	body, _ := json.Marshal(form)

	ser := testtool.NewTestServer(SerCtx, "POST", "/api/auth", bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &authmodel.AuthPo{}
		SerCtx.Db.Model(po).Where("code=?", form.Code).Take(po)
		assert.Equal(t, po.Name, form.Name, "name not equal")
		assert.Equal(t, po.Method, form.Method, "method not equal")
		assert.Equal(t, po.Api, form.Api, "api not equal")
		assert.Equal(t, po.OrderNum, form.OrderNum, "order not equal")
		assert.Equal(t, po.Kind, form.Kind, "kind not equal")
	}

}
