package admin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func TestCreateUser(t *testing.T) {

	var tests = []struct {
		Name string
		Po   adminmodel.AdminPo
	}{
		{
			"createuser",
			adminmodel.AdminPo{
				Phone:        "19931937279",
				Account:      "abcd",
				Name:         "张三",
				Password:     "123",
				IsSuperAdmin: "0",
				Status:       "1",
				Email:        "270@qq.com",
			},
		},
		{
			"unique account",
			adminmodel.AdminPo{
				Phone:        "19931937278",
				Account:      "abcd",
				Name:         "张三",
				Password:     "123",
				IsSuperAdmin: "0",
				Status:       "1",
				Email:        "2701@qq.com",
			},
		},
		{
			"unique phone",
			adminmodel.AdminPo{
				Phone:        "19931937279",
				Account:      "abcd1",
				Name:         "张三",
				Password:     "123",
				IsSuperAdmin: "0",
				Status:       "1",
				Email:        "274@qq.com",
			},
		},
		{
			"Email",
			adminmodel.AdminPo{
				Phone:        "19931937276",
				Account:      "abcd1",
				Name:         "张三",
				Password:     "123",
				IsSuperAdmin: "0",
				Status:       "1",
				Email:        "270",
			},
		},
	}

	for k, v := range tests {
		w := httptest.NewRecorder()
		bts, _ := json.Marshal(&v.Po)
		req := httptest.NewRequest("POST", "/api/admin", bytes.NewBuffer(bts))

		req.Header.Add("Authorization", accsessToken)

		engine.ServeHTTP(w, req)

		switch k {
		case 0:
			if assert.Equal(t, w.Code, 200, "%s:%s", v.Name, w.Body.String()) {
				tmp := &adminmodel.AdminPo{}
				sc.Db.Where("account=?", "abcd").Take(tmp)
				assert.Equal(t, tmp.Status, "1")
				assert.Equal(t, tmp.IsSuperAdmin, "0")
			}
		case 1:
			if assert.Equal(t, w.Code, 400, "%s:%s", v.Name, w.Body.String()) {
				assert.Contains(t, w.Body.String(), "账号已存在", "%s:%s", v.Name, "账号已存在")
			}
		case 2:
			if assert.Equal(t, w.Code, 400, "%s:%s", v.Name, w.Body.String()) {
				assert.Contains(t, w.Body.String(), "手机号已存在", "%s:%s", v.Name, "手机号已存在")
			}
		case 3:
			if assert.Equal(t, w.Code, 400, "%s:%s", v.Name, w.Body.String()) {
				assert.Contains(t, w.Body.String(), "AdminPostPo.Email", "%s:%s", v.Name, "AdminPo.Email")
			}
		}
	}
}