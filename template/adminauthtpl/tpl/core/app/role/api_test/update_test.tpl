package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestUpdateRole(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + rolemodel.RolePo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po1 := &rolemodel.RolePo{Code: "code1", Name: "name1", OrderNum: 1, Status: "1", Memo: "memo1"}
	SerCtx.Db.Create(po1)

	form := &rolemodel.RoleForm{Name: "nameupdate", OrderNum: 2, Status: "0", Memo: "updateMemo"}
	body, _ := json.Marshal(form)
	ser := testtool.NewTestServer(SerCtx, "PUT", fmt.Sprintf("/api/role/%d", po1.ID), bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()

	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &rolemodel.RolePo{}
		SerCtx.Db.Where("id=?", po1.ID).Take(po)
		assert.Equal(t, po.Code, po1.Code)
		assert.NotEmpty(t, po.Name, po1.Name)
		assert.NotEmpty(t, po.OrderNum, po1.OrderNum)
		assert.NotEmpty(t, po.Status, po1.Status)
		assert.NotEmpty(t, po.Memo, po1.Memo)
	}
}
