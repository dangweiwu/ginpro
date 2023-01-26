package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"strconv"
	"testing"
)

func TestResetPwd(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	user := testtool.NewMockUser(TestCtx).Create("account", "name", "0","11111111111")

	ser := testtool.NewTestServer(SerCtx, "PUT", "/api/admin/resetpwd/"+strconv.Itoa(int(my.Po.ID)), nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 400, "%s:%s", "resetpwd-id:"+strconv.Itoa(int(my.Po.ID)), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "不能重置自己密码", "密码设定:不能重置自己密码。%s", ser.GetBody())
	}

	ser = testtool.NewTestServer(SerCtx, "PUT", "/api/admin/resetpwd/"+strconv.Itoa(int(user.Po.ID)), nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "resetpwd-id:"+strconv.Itoa(int(user.Po.ID)), ser.GetBody()) {
		assert.Len(t, ser.GetBody(), 17, "resetpwd-len:17")
	}

	ser = testtool.NewTestServer(SerCtx, "PUT", "/api/admin/resetpwd/1000", nil).SetAuth(my.AccessToken).Do()

	if assert.Equal(t, ser.GetCode(), 400, "%s:%s", "resetpwd-no-id:1000", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "记录不存在", "resetpwd-no-id:1000:记录不存在")
	}

}
