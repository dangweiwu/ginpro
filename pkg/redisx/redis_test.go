package redisx

import (
	"context"
	"github.com/alicebob/miniredis/v2"
	"github.com/stretchr/testify/assert"
	"github.com/dangweiwu/ginpro/pkg/redisx/redisconfig"
	"testing"
	"time"
)

func TestNewRedis(t *testing.T) {
	r := miniredis.RunT(t)
	cfg := redisconfig.RedisConfig{}
	cfg.Addr = r.Addr()
	cli, err := NewRedis(cfg).GetDb()
	assert.Nil(t, err, "redis连接失败")

	//基本测试
	key := "a"
	value := "b"
	ctx := context.Background()
	rdcmd := cli.Set(ctx, key, value, 0)
	assert.Nil(t, rdcmd.Err(), "set err")
	r.FastForward(100 * time.Hour)
	rdstus := cli.Get(ctx, key)
	assert.Nil(t, rdstus.Err(), "get err")
	rdvalue, err := rdstus.Result()
	assert.Nil(t, rdstus.Err(), "get result err")
	assert.Equal(t, rdvalue, value, "get value not equal")
}
