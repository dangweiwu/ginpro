package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAuthQuery(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + authmodel.AuthPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())

	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po1 := &authmodel.AuthPo{Name: "创建", Code: "create", OrderNum: 1001, Api: "/api/auth", Method: "POST", Kind: "0"}
	SerCtx.Db.Create(po1)
	//
	po2 := &authmodel.AuthPo{Name: "查询", Code: "query", OrderNum: 1002, Api: "/api/auth", Method: "GET", Kind: "0"}
	SerCtx.Db.Create(po2)
	//
	po3 := &authmodel.AuthPo{Name: "更新", Code: "update", OrderNum: 1003, Api: "/api/auth/:id", Method: "PUT", Kind: "0"}
	SerCtx.Db.Create(po3)
	//
	po4 := &authmodel.AuthPo{Name: "删除", Code: "delete", OrderNum: 1004, Api: "/api/auth/:id", Method: "DELETE", Kind: "0"}
	SerCtx.Db.Create(po4)

	po5 := &authmodel.AuthPo{Name: "权限管理", Code: "auth", OrderNum: 1000, Api: "", Method: "", Kind: "1"}
	SerCtx.Db.Create(po5)

	ser := testtool.NewTestServer(SerCtx, "GET", "/api/auth", nil).SetAuth(my.AccessToken).Do()
	//fmt.Println(ser.GetBody())

	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":5`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/auth?name=创建", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":1`)
		assert.Contains(t, ser.GetBody(), `创建`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/auth?code=create", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":1`)
		assert.Contains(t, ser.GetBody(), `创建`)
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/auth?api=/api/auth", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":4`)
	}
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/auth?kind=1", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), `"total":1`)
		assert.Contains(t, ser.GetBody(), `权限管理`)
	}

}
