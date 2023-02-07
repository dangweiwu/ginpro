package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/testtool"
	"fmt"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestRoleDelete(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + rolemodel.RolePo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po := &rolemodel.RolePo{Code: "code", Name: "name", OrderNum: 1, Status: "1", Memo: "memo"}
	SerCtx.Db.Create(po)

	po1 := &rolemodel.RolePo{Code: "code1", Name: "name1", OrderNum: 1, Status: "1", Memo: "memo1"}
	SerCtx.Db.Create(po1)

	ser := testtool.NewTestServer(SerCtx, "DELETE", fmt.Sprintf("/api/role/%d", po1.ID), nil).SetAuth(my.AccessToken).Do()
	assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody())

}
