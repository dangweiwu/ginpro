package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAuthTree(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + authmodel.AuthPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())

	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po5 := &authmodel.AuthPo{Name: "权限管理", Code: "auth", OrderNum: 100100, Api: "", Method: "", Kind: "1"}
	po5.ID = 1
	SerCtx.Db.Create(po5)

	po1 := &authmodel.AuthPo{Name: "创建", Code: "create", OrderNum: 100101, Api: "/api/auth", Method: "POST", Kind: "0"}
	po1.ParentId = 1
	SerCtx.Db.Create(po1)
	//
	po2 := &authmodel.AuthPo{Name: "查询", Code: "query", OrderNum: 100102, Api: "/api/auth", Method: "GET", Kind: "0"}
	po2.ParentId = 1
	SerCtx.Db.Create(po2)
	//
	po3 := &authmodel.AuthPo{Name: "更新", Code: "update", OrderNum: 100103, Api: "/api/auth/:id", Method: "PUT", Kind: "0"}
	po3.ParentId = 1
	SerCtx.Db.Create(po3)
	//
	po4 := &authmodel.AuthPo{Name: "删除", Code: "delete", OrderNum: 100104, Api: "/api/auth/:id", Method: "DELETE", Kind: "0"}
	po4.ParentId = 1
	SerCtx.Db.Create(po4)

	ser := testtool.NewTestServer(SerCtx, "GET", "/api/auth/tree", nil).SetAuth(my.AccessToken).Do()
	//fmt.Println("数据查看", ser.GetBody())
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		//fmt.Println("获取数据", ser.GetBody())
		assert.Contains(t, ser.GetBody(), po5.Name)
		assert.Contains(t, ser.GetBody(), po1.Name)
		assert.Contains(t, ser.GetBody(), po2.Name)
		assert.Contains(t, ser.GetBody(), po3.Name)
		assert.Contains(t, ser.GetBody(), po4.Name)
	}
}
