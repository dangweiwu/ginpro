package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/testtool"
	"fmt"
	"github.com/stretchr/testify/assert"
	"gorm.io/gorm"
	"testing"
)

func TestAuthDel(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + authmodel.AuthPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())

	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po1 := &authmodel.AuthPo{Name: "创建", Code: "create", OrderNum: 1001, Api: "/api/auth", Method: "POST", Kind: "0"}
	SerCtx.Db.Create(po1)

	ser := testtool.NewTestServer(SerCtx, "DELETE", fmt.Sprintf("/api/auth/%d", po1.ID), nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		err := SerCtx.Db.Model(po1).Where("id=?", po1.ID).Take(po1).Error
		assert.Equal(t, err, gorm.ErrRecordNotFound)
	}
}
