package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestUpdateMyPwd(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}
	form := &mymodel.PasswordForm{my.Password, "a123456"}
	bts, _ := json.Marshal(form)
	ser := testtool.NewTestServer(SerCtx, "PUT", "/api/my/password", bytes.NewBuffer(bts)).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "uppwd:%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &adminmodel.AdminPo{}
		SerCtx.Db.Where("account=?", my.Account).Take(po)
		assert.Equal(t, po.Password, pkg.GetPassword(form.NewPassword))
	}
}
