package redisx

import (
	"context"
	"fmt"
	"github.com/go-redis/redis/v8"
	"gs/pkg/redisx/redisconfig"
	"sync"
)

var _r *redis.Client
var once sync.Once

type Redis struct {
	cfg redisconfig.RedisConfig
}

func NewRedis(cfg redisconfig.RedisConfig) *Redis {
	return &Redis{cfg}
}

func (this *Redis) GetDb() (db *redis.Client, err error) {
	//fmt.Println("@@.......")
	if _r == nil {
		once.Do(func() {
			_r = redis.NewClient(&redis.Options{
				Addr:     this.cfg.Addr,
				Password: this.cfg.Password,
				DB:       this.cfg.Db,
			})

			if _, _err := _r.Ping(context.Background()).Result(); _err != nil {
				err = _err
			}
		})
		return _r, err
	} else {
		fmt.Println("_r", _r)
		return _r, nil
	}
}
