package admin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"fmt"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func TestGet(t *testing.T) {
	//前置条件
	po := &adminmodel.AdminPo{
		Account: "get:account1",
		Phone:   "19931937000",
		Email:   "get:em@qq.com",
		Name:    "get:name",
	}
	sc.Db.Create(po)

	var tests = []struct {
		Name       string
		ParamKey   string
		ParamValue string
	}{
		{
			Name:       "get account",
			ParamKey:   "account",
			ParamValue: "abcd",
		},
		{
			Name:       "get account",
			ParamKey:   "account",
			ParamValue: "get:acco",
		},
		{
			Name:       "get phone",
			ParamKey:   "phone",
			ParamValue: "7000",
		},
		{
			Name:       "get email",
			ParamKey:   "email",
			ParamValue: "get:em",
		},
		{
			Name:       "get Name",
			ParamKey:   "name",
			ParamValue: "get:na",
		},
	}

	for i, v := range tests {
		w := httptest.NewRecorder()
		req := httptest.NewRequest("GET", fmt.Sprintf("/api/admin?%s=%s", v.ParamKey, v.ParamValue), nil)
		req.Header.Add("Authorization", accsessToken)
		engine.ServeHTTP(w, req)
		if i == 0 {
			//bts := w.Body.Bytes()
			//fmt.Println("@@", string(bts))
			if assert.Equal(t, w.Code, 200, "%s", v.Name) {
				assert.Contains(t, w.Body.String(), `"total":0`)
			}
		} else {
			if assert.Equal(t, w.Code, 200, "%s", v.Name) {
				assert.Contains(t, w.Body.String(), `"total":1`, i)
			}
		}

	}
}