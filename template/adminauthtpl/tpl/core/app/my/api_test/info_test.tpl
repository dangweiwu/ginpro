package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestInfo(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	ser := testtool.NewTestServer(SerCtx, "GET", "/api/my", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "my:info:%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "admin")
	}

}
