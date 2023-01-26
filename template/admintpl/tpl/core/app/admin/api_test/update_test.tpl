package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAdminUpdate(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	user := &adminmodel.AdminPo{
		Account: "account", Name: "name", IsSuperAdmin: "1", Status: "1", Password: "123456", Memo: "memo",
		Email: "email@qq.com", Phone: "123456789"}
	SerCtx.Db.Create(user)

	upform := &adminmodel.AdminUpdateForm{Phone: "12312312311", Name: "namechang", Status: "0",
		Memo: "memochange", Email: "email@qq.com", IsSuperAdmin: "1"}
	bts, _ := json.Marshal(upform)

	ser := testtool.NewTestServer(SerCtx, "PUT", fmt.Sprintf("/api/admin/%d", user.ID), bytes.NewBuffer(bts)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "update %d:%s", ser.GetCode(), ser.GetBody()) {
		newPo := &adminmodel.AdminPo{}
		SerCtx.Db.Where("account=?", user.Account).Take(newPo)
		assert.Equal(t, upform.Phone, newPo.Phone, "update:phone")
		assert.Equal(t, upform.Name, newPo.Name, "update:name")
		assert.Equal(t, upform.Status, newPo.Status, "update:status")
		assert.Equal(t, upform.Memo, newPo.Memo, "update:memo")
		assert.Equal(t, upform.Email, newPo.Email, "update:email")
		assert.Equal(t, upform.IsSuperAdmin, newPo.IsSuperAdmin, "update:update")

	}

	my.Po.Status = "0"
	bts, _ = json.Marshal(my.Po)
	ser = testtool.NewTestServer(SerCtx, "PUT", fmt.Sprintf("/api/admin/%d", my.Po.ID), bytes.NewBuffer(bts)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 400, "update %d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "不能禁用自己", "update:不能禁用自己:%s", ser.GetBody())
	}
}
