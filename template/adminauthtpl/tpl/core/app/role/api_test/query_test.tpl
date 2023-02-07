package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestRoleQuery(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + rolemodel.RolePo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po1 := &rolemodel.RolePo{Code: "code1", Name: "name1", OrderNum: 1, Status: "1", Memo: "memo1"}
	SerCtx.Db.Create(po1)
	po2 := &rolemodel.RolePo{Code: "code2", Name: "name2", OrderNum: 2, Status: "1", Memo: "memo2"}
	SerCtx.Db.Create(po2)

	ser := testtool.NewTestServer(SerCtx, "GET", "/api/role", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":2`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/role?name=name1", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":1`)
		assert.Contains(t, ser.GetBody(), `name1`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/role?name=name", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":2`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/role?code=code1", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":1`)
		assert.Contains(t, ser.GetBody(), `code1`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/role?code=code", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":2`)
	}
}
