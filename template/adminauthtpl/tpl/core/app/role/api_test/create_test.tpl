package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestCreateRole(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + rolemodel.RolePo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	form := &rolemodel.RoleForm{Code: "admin", Name: "系统管理员", OrderNum: 1, Status: "1", Memo: "this is memo"}
	body, _ := json.Marshal(form)
	ser := testtool.NewTestServer(SerCtx, "POST", "/api/role", bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &rolemodel.RolePo{}
		SerCtx.Db.Where("code=?", form.Code).Take(po)
		assert.Equal(t, po.Name, form.Name)
		assert.Equal(t, po.Status, form.Status)
		assert.Equal(t, po.OrderNum, form.OrderNum)
		assert.Equal(t, po.Code, form.Code)
		assert.Equal(t, po.Memo, form.Memo)
	}

	ser = testtool.NewTestServer(SerCtx, "POST", "/api/role", bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 400, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "角色编码已存在")
	}
}
