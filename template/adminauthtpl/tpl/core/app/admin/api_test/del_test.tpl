package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"strconv"
	"testing"
)

func TestAdminDel(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}
	user := &adminmodel.AdminPo{Account: "account", Name: "name", Phone: "12345678911", Email: "email@qq.com"}
	r := SerCtx.Db.Create(user)
	assert.Equal(t, r.Error, nil, "del:add user")

	ser := testtool.NewTestServer(SerCtx, "DELETE", "/api/admin/"+strconv.Itoa(int(user.ID)), nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 200, "delete user::code:%s-body:%s", ser.GetCode(), ser.GetBody())

	//no test
	ser = testtool.NewTestServer(SerCtx, "DELETE", "/api/admin/1000", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 400, "delete no id user::code:%s-body:%s", ser.GetCode(), ser.GetBody())

}
