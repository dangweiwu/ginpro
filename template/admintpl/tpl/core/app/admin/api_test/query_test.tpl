package api_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

/*
查询测试
查询条件 account phone name email
*/

func TestAdminQuery(t *testing.T) {
	SerCtx.Db.Exec("DELETE FROM " + adminmodel.AdminPo{}.TableName())
	my := testtool.NewMockUser(TestCtx).Mock().Login().SetLogCode()
	if my.Err != nil {
		t.Fatal(my.Err)
	}
	accountUser := &adminmodel.AdminPo{Account: "account1", Name: "name1", Phone: "12345678911", Email: "email1@qq.com"}
	phoneUser := &adminmodel.AdminPo{Account: "account2", Name: "name2", Phone: "12345678912", Email: "email2@qq.com"}
	nameUser := &adminmodel.AdminPo{Account: "account3", Name: "name3", Phone: "12345678913", Email: "email3@qq.com"}
	emailUser := &adminmodel.AdminPo{Account: "account4", Name: "name4", Phone: "12345678914", Email: "email4@qq.com"}
	SerCtx.Db.Create(accountUser)
	SerCtx.Db.Create(phoneUser)
	SerCtx.Db.Create(nameUser)
	SerCtx.Db.Create(emailUser)

	//account test
	ser := testtool.NewTestServer(SerCtx, "GET", "/api/admin?account=account1", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:account=account1", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":1", "account1-total1")
		assert.Contains(t, ser.GetBody(), "account1", "account1-account1")
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?account=account", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:account=account", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":4", "account-total4")
	}

	//name test
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?name=name1", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:name=mame1", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":1", "name1-total1")
		assert.Contains(t, ser.GetBody(), "name1", "name1-name1")
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?name=name", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:name=name", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":4", "mame-total4")
	}

	//phone test
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?phone=12345678911", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:phone=1", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":1", "phone-total1")
		assert.Contains(t, ser.GetBody(), "12345678911", "phone-1")
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?phone=1234567891", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:phone=1*", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":4", "phone-total4")
	}

	//Email Test
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?email=email1@qq.com", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:email=1", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":1", "email-total1")
		assert.Contains(t, ser.GetBody(), "email1@qq.com", "email-1")
	}

	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?email=email", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:email=email*", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":4", "email-total4")
	}

	//no
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?account=12345", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:noaccount:123456", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":0", "no-total0")
	}

	//all
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:all", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":5", "all-total:5")
	}

	//联合参数查询
	ser = testtool.NewTestServer(SerCtx, "GET", "/api/admin?account=acc&&name=nam&&phone=123&&email=ema", nil).SetAuth(my.AccessToken).Do()
	if assert.Equal(t, ser.GetCode(), 200, "%s:%s", "query:all-union", ser.GetBody()) {
		assert.Contains(t, ser.GetBody(), "\"total\":4", "all-union-total:4")
	}

}
