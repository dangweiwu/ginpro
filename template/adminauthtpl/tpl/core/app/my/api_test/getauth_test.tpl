package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/testtool"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestGetAuth(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())

	role := rolemodel.RolePo{Code: "admin", Auth: []string{"pageadmin"}}
	r := SerCtx.Db.Create(&role)
	fmt.Println(r.Error)

	my := testtool.NewMockUser(TestCtx).MockRole("admin").Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	ser := testtool.NewTestServer(SerCtx, "GET", "/api/my-auth", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, ":%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "pageadmin")
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my-auth", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, ":%d:%s", ser.GetCode(), ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "pageadmin")
	}
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	role2 := rolemodel.RolePo{Code: "admin1", Auth: []string{"pageadmin"}, Status: "0"}
	SerCtx.Db.Create(&role2)

	my = testtool.NewMockUser(TestCtx).MockRole("admin1").Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my-auth", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 401, ":%d:%s", ser.GetCode(), ser.GetBody())
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my-auth", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 401, ":%d:%s", ser.GetCode(), ser.GetBody())

	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my = testtool.NewMockUser(TestCtx).MockRole("admin2").Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my-auth", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 400, ":%d:%s", ser.GetCode(), ser.GetBody())
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/my-auth", nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, ser.GetCode(), 400, ":%d:%s", ser.GetCode(), ser.GetBody())
}
