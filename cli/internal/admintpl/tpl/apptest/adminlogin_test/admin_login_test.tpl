package adminlogin_test

import (
	"{{.Module}}/internal/app/admin/handler"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func login(t *testing.T) {
	w := httptest.NewRecorder()

	loginform := handler.LoginForm{
		Account:  user,
		Password: password,
	}

	bts, _ := json.Marshal(&loginform)
	req := httptest.NewRequest("POST", "/admin/login", bytes.NewBuffer(bts))

	engine.ServeHTTP(w, req)

	if assert.Equal(t, w.Code, 200) {
		rmap := map[string]interface{}{}
		json.Unmarshal(w.Body.Bytes(), &rmap)
		if assert.NotEmpty(t, rmap["AccessToken"]) {
			accsessToken = rmap["AccessToken"].(string)
		}
		if assert.NotEmpty(t, rmap["RefreshToken"]) {
			refleshToken = rmap["RefreshToken"].(string)
		}
		if assert.NotEmpty(t, rmap["RefreshAt"]) {
			refleshTime = int64(rmap["RefreshAt"].(float64))
		}
	}
}
