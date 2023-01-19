package admin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"strconv"
	"testing"
)

func TestAdminResetpwd(t *testing.T) {
	pwd := "123abc"
	po := &adminmodel.AdminPo{}
	po.Account = "adminResetpwd"
	po.Password = pkg.GetPassword(pwd)

	sc.Db.Create(po)

	w := httptest.NewRecorder()
	//bts, _ := json.Marshal(v.form)
	req := httptest.NewRequest("PUT", "/api/admin/resetpwd/"+strconv.Itoa(int(po.ID)), nil)
	req.Header.Add("Authorization", accsessToken)
	engine.ServeHTTP(w, req)

	assert.Equal(t, w.Code, 200)

	tmpPo := &adminmodel.AdminPo{}
	sc.Db.Where("id=?", po.ID).Take(tmpPo)
	assert.Equal(t, tmpPo.Password, pkg.GetPassword(cfg.Admin.RawPassword))
	sc.Db.Delete(po)
}