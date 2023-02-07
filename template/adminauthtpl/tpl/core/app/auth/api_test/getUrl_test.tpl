package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/pkg/fullurl"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGetUrl(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + authmodel.AuthPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())

	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	cli := testtool.NewTestServer(SerCtx, "GET", "/api/allurl", nil)
	fullurl.NewFullUrl().InitUrl(cli.Engine)
	rt := cli.SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, rt.GetCode()) {
		assert.NotContains(t, rt.GetBody(), "/api/allurl")
		assert.Contains(t, rt.GetBody(), "/api/auth")
	}
}
