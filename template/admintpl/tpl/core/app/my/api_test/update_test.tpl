package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/my/mymodel"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestMyUpdate(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	form := &mymodel.MyForm{Phone: "12345678911", Name: "name", Memo: "memo", Email: "email@qq.com"}
	bts, _ := json.Marshal(form)

	ser := testtool.NewTestServer(SerCtx, "PUT", "/api/my", bytes.NewBuffer(bts)).SetAuth(my.AccessToken).Do()

	if assert.Equal(t, ser.GetCode(), 200, "updatemy:%d:%s", ser.GetCode(), ser.GetBody()) {
		po := &adminmodel.AdminPo{}
		SerCtx.Db.Where("account=?", my.Account).Take(po)
		assert.Equal(t, form.Phone, po.Phone)
		assert.Equal(t, form.Name, po.Name)
		assert.Equal(t, form.Memo, po.Memo)
		assert.Equal(t, form.Email, po.Email)
	}

}
