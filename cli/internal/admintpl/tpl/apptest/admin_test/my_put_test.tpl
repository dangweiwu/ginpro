package admin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func TestMyPut(t *testing.T) {
	w := httptest.NewRecorder()
	po := adminmodel.AdminPo4{
		Name:  "myname",
		Phone: "12345678909",
		Email: "myput@qq.com",
		Memo:  "mymemeo",
	}
	bts, _ := json.Marshal(po)
	req := httptest.NewRequest("PUT", "/api/admin/my", bytes.NewBuffer(bts))
	req.Header.Add("Authorization", accsessToken)
	//fmt.Println(accsessToken)
	engine.ServeHTTP(w, req)

	if assert.Equal(t, w.Code, 200) {
		rpo := &adminmodel.AdminPo4{}
		sc.Db.Model(rpo).Where("id=?", 1).Take(rpo)
		assert.Equal(t, po.Phone, rpo.Phone)
		assert.Equal(t, po.Name, rpo.Name)
		assert.Equal(t, po.Email, rpo.Email)
		assert.Equal(t, po.Memo, rpo.Memo)
	}
}