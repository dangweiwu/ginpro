package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestLogout(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	ser := testtool.NewTestServer(SerCtx, "POST", "/api/logout", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 200, "logout:%d:%s", ser.GetCode(), ser.GetBody())

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 401, "my:info:%d:%s", ser.GetCode(), ser.GetBody())

}
