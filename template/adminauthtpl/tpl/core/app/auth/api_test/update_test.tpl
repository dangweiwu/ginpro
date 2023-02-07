package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAuthUpdate(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + authmodel.AuthPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())

	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po1 := &authmodel.AuthPo{Name: "创建", Code: "create", OrderNum: 1001, Api: "/api/auth", Method: "POST", Kind: "0"}
	SerCtx.Db.Create(po1)

	po2 := &authmodel.AuthPo{Name: "查询", Code: "query", OrderNum: 1002, Api: "/api/auth", Method: "GET", Kind: "0"}
	SerCtx.Db.Create(po2)
	//

	form := authmodel.AuthUpdateForm{Name: "创建1", OrderNum: 1002, Api: "/api/auth1", Method: "PUT", Kind: "0"}
	bts, _ := json.Marshal(form)
	ser := testtool.NewTestServer(SerCtx, "PUT", fmt.Sprintf("/api/auth/%d", po1.ID), bytes.NewBuffer(bts)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &authmodel.AuthPo{}
		SerCtx.Db.Where("id=?", po1.ID).Take(po)
		assert.Equal(t, po.Name, form.Name)
		assert.Equal(t, po.Code, po1.Code)
		assert.Equal(t, po.OrderNum, form.OrderNum)
		assert.Equal(t, po.Api, form.Api)
		assert.Equal(t, po.Method, form.Method)
		assert.Equal(t, po.Kind, form.Kind)

		rpo := &authmodel.AuthPo{}
		SerCtx.Db.Where("id=?", po2.ID).Take(rpo)
		assert.Equal(t, rpo.Name, po2.Name)

	}

}
