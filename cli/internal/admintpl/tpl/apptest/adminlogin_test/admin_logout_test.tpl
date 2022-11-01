package adminlogin_test

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"github.com/go-redis/redis"
	"github.com/stretchr/testify/assert"
	"net/http/httptest"
	"testing"
)

func logout(t *testing.T) {
	w := httptest.NewRecorder()
	req := httptest.NewRequest("POST", "/api/admin/my/logout", nil)
	req.Header.Add("Authorization", accsessToken)
	engine.ServeHTTP(w, req)
	if assert.Equal(t, w.Code, 200, w.Body.String()) {
		po := &adminmodel.AdminPo{}
		sc.Db.Model(po).Where("account=?", user).Take(po)
		id, err := sc.Redis.Get(adminmodel.GetAdminRedisRefreshTokenId(int(po.ID))).Result()

		assert.Equal(t, len(id), 0, id)
		assert.Equal(t, err, redis.Nil)

		id, err = sc.Redis.Get(adminmodel.GetAdminRedisLoginId(int(po.ID))).Result()
		assert.Equal(t, len(id), 0, id)
		assert.Equal(t, err, redis.Nil)

	}
}