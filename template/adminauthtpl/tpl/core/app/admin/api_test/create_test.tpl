package api_test

import (
	"bytes"
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"{{.Module}}/internal/testtool"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAdminCreate(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	tests := []struct {
		name    string
		Method  string
		Target  string
		wantErr bool
		po      *adminmodel.AdminForm
	}{
		{"创建", "POST", "/api/admin", false,
			&adminmodel.AdminForm{Name: "dang", Phone: "12345678911", Account: "dang", Password: "123456", IsSuperAdmin: "0", Status: "1", Email: "abc1@qq.com"}},
		{"重复账号", "POST", "/api/admin", false,
			&adminmodel.AdminForm{Name: "dang", Phone: "12345678911", Account: "dang", Password: "123456", IsSuperAdmin: "0", Status: "1", Email: "abc2@qq.com"}},
		{"email格式", "POST", "/api/admin", false,
			&adminmodel.AdminForm{Name: "dang", Phone: "12345678912", Account: "dang3", Password: "123456", IsSuperAdmin: "0", Status: "1", Email: "abc"}},
	}
	for k, tt := range tests {
		body, _ := json.Marshal(tt.po)
		switch k {
		case 0:

			ser := testtool.NewTestServer(SerCtx, tt.Method, tt.Target, bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
			if assert.Equal(t, 200, ser.GetCode(), "%s:%s", tt.name, ser.GetBody()) {
				rpo := &adminmodel.AdminPo{}
				SerCtx.Db.Where("account=?", "dang").Take(rpo)
				assert.Equal(t, rpo.Phone, tt.po.Phone)
				assert.Equal(t, rpo.Name, tt.po.Name)
				assert.Equal(t, rpo.Password, pkg.GetPassword(tt.po.Password))
				assert.Equal(t, rpo.IsSuperAdmin, tt.po.IsSuperAdmin)
				assert.Equal(t, rpo.Status, tt.po.Status)
			}
		case 1:
			ser := testtool.NewTestServer(SerCtx, tt.Method, tt.Target, bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
			if assert.Equal(t, 400, ser.GetCode(), "%s:%s", tt.name, ser.GetBody()) {
				assert.Contains(t, ser.GetBody(), "账号已存在", "%s:%s", tt.name, "账号已存在")
			}

		case 2:
			ser := testtool.NewTestServer(SerCtx, tt.Method, tt.Target, bytes.NewBuffer(body)).SetAuth(my.AccessToken).Do()
			if assert.Equal(t, 400, ser.GetCode(), "%s:%s", tt.name, ser.GetBody()) {
				assert.Contains(t, ser.GetBody(), "AdminForm.Email", "%s:%s", tt.name, "AdminForm.Email")
			}

		}

	}

}
