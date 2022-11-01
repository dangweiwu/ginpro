package admin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"strconv"
	"testing"
)

func TestDel(t *testing.T) {
	//初始化
	po := &adminmodel.AdminPo{}
	po.Phone = "19931937300"
	po.Account = "del:demo"
	po.Email = "3@qq.com"
	po.Status = "1"
	po.Memo = "update:this is memo"
	po.IsSuperAdmin = "1"

	r := sc.Db.Create(po)
	if r.Error != nil {
		panic(r.Error)
	}

	var tests = []struct {
		Name string
		Po   *adminmodel.AdminPo2
	}{
		{
			Name: "update user",
			Po: &adminmodel.AdminPo2{
				Name:         "update:aft1",
				Phone:        "19931937777",
				Email:        "2@2.qq",
				Status:       "0",
				Memo:         "update:aftmemo",
				IsSuperAdmin: "0",
			},
		},
	}

	for k, v := range tests {
		w := httptest.NewRecorder()
		bts, _ := json.Marshal(&v.Po)
		req := httptest.NewRequest("DELETE", "/api/admin/"+strconv.Itoa(int(po.ID)), bytes.NewBuffer(bts))

		req.Header.Add("Authorization", accsessToken)

		engine.ServeHTTP(w, req)
		switch k {
		case 0:
			if assert.Equal(t, w.Code, 200, "%s:%s", v.Name, w.Body.String()) {
				ct := int64(0)
				sc.Db.Model(&adminmodel.AdminPo{}).Where("id=?", po.ID).Count(&ct)
				assert.Equal(t, ct, int64(0), "%s:%d", v.Name, ct)
			}
		}
	}
}