package admin_test

import (
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func TestMyGet(t *testing.T) {

	w := httptest.NewRecorder()
	req := httptest.NewRequest("GET", "/api/admin/my", nil)
	req.Header.Add("Authorization", accsessToken)
	//fmt.Println(accsessToken)
	engine.ServeHTTP(w, req)
	if assert.Equal(t, w.Code, 200) {
		assert.Contains(t, w.Body.String(), "name")
	}
}