package admin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/app/admin/handler"
	"{{.Module}}/internal/pkg"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func TestMyResetpwd(t *testing.T) {

	var tests = []struct {
		Name string
		form handler.PasswordForm
	}{
		{
			Name: "err password",
			form: handler.PasswordForm{
				Password:    password + "1",
				NewPassword: "",
			},
		},
		{
			Name: "ok password",
			form: handler.PasswordForm{
				Password:    password,
				NewPassword: "abc123",
			},
		},
	}

	for k, v := range tests {
		w := httptest.NewRecorder()
		bts, _ := json.Marshal(&v.form)
		req := httptest.NewRequest("PUT", "/api/admin/my/password", bytes.NewBuffer(bts))

		req.Header.Add("Authorization", accsessToken)

		engine.ServeHTTP(w, req)
		switch k {
		case 0:
			assert.Equal(t, w.Code, 400)
		case 1:
			if assert.Equal(t, w.Code, 200) {
				tmpPo := &adminmodel.AdminPo{}
				sc.Db.Where("account=?", user).Take(tmpPo)
				assert.Equal(t, tmpPo.Password, pkg.GetPassword(v.form.NewPassword))
			}
		}
	}
}
