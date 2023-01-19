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
		if assert.NotEmpty(t, rmap["access_token"]) {
			accsessToken = rmap["access_token"].(string)
		}
		if assert.NotEmpty(t, rmap["refresh_token"]) {
			refleshToken = rmap["refresh_token"].(string)
		}
		if assert.NotEmpty(t, rmap["refresh_at"]) {
			refleshTime = int64(rmap["refresh_at"].(float64))
		}
	}
}
