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

func TestRefreshToken(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}

	form := &mymodel.RefreshTokeForm{my.RefreshToken}
	bts, _ := json.Marshal(form)
	ser := testtool.NewTestServer(SerCtx, "POST", "/api/token/refresh", bytes.NewBuffer(bts)).SetAuth(my.AccessToken).Do()

	if assert.Equal(t, ser.GetCode(), 200, "refreshtoken:%d:%s", ser.GetCode(), ser.GetBody()) {
		rep := &mymodel.LogRep{}
		json.Unmarshal([]byte(ser.GetBody()), rep)
		assert.NotEmpty(t, rep.AccessToken, "accesstoken")
        assert.NotEqual(t, rep.RefreshToken, my.RefreshToken, "refreshtoken")
	}

}
