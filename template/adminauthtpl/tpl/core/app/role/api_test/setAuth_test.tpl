package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"fmt"
	"github.com/stretchr/testify/assert"
	"{{.Host}}/pkg/dbtype"
	"testing"
)

func TestAetAuth(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	SerCtx.Db.Exec("DELETE FROM " + rolemodel.RolePo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	po1 := &rolemodel.RolePo{Code: "code1", Name: "name1", OrderNum: 1, Status: "1", Memo: "memo1"}
	SerCtx.Db.Create(po1)

	authpo := &authmodel.AuthPo{Code: "abc"}
	SerCtx.Db.Create(authpo)
	authpo1 := &authmodel.AuthPo{Code: "123"}
	SerCtx.Db.Create(authpo1)

	form := &rolemodel.RoleAuthForm{Auth: dbtype.List[string]{"abc", "123"}}
	body, _ := json.Marshal(form)
	ser := testtool.NewTestServer(SerCtx, "PUT", fmt.Sprintf("/api/role/auth/%d", po1.ID), bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, 200, ser.GetCode(), "%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &rolemodel.RolePo{}
		err := SerCtx.Db.Model(po).Where("id=?", po1.ID).Take(po).Error
		assert.Nil(t, err)
		bts1, _ := json.Marshal(form.Auth)
		bts2, _ := json.Marshal(po.Auth)
		assert.Equal(t, bts1, bts2)
	}
}
