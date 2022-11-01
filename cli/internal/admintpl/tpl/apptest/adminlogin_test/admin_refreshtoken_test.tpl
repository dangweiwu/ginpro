package adminlogin_test

import (
	"{{.Module}}/internal/app/admin/handler"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func refreshTokenf(t *testing.T) {
	w := httptest.NewRecorder()

	loginform := handler.RefreshTokeForm{
		refleshToken,
	}

	bts, _ := json.Marshal(&loginform)
	req := httptest.NewRequest("POST", "/api/token/reflesh", bytes.NewBuffer(bts))
	req.Header.Add("Authorization", accsessToken)
	engine.ServeHTTP(w, req)
	if assert.Equal(t, w.Code, 200, w.Body.String()) {
		rmap := map[string]interface{}{}
		json.Unmarshal(w.Body.Bytes(), &rmap)
		assert.NotEmpty(t, rmap["access_token"])
		accsessToken = rmap["access_token"].(string)
		assert.NotEmpty(t, rmap["refresh_token"])
		assert.NotEqual(t, rmap["refresh_token"], refleshToken)
		assert.NotEmpty(t, rmap["refresh_at"])
	}

	w = httptest.NewRecorder()

	loginform = handler.RefreshTokeForm{
		refleshToken,
	}

	bts, _ = json.Marshal(&loginform)
	req = httptest.NewRequest("POST", "/api/token/reflesh", bytes.NewBuffer(bts))
	req.Header.Add("Authorization", accsessToken)
	engine.ServeHTTP(w, req)

	assert.Equal(t, w.Code, 401)
	assert.Contains(t, w.Body.String(), "refreshtoken已失效")

}
