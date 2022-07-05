package redisx

import (
	"gs/pkg/redisx/redisconfig"
	"sync"

	"github.com/go-redis/redis"
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
	if _r == nil {
		once.Do(func() {
			_r = redis.NewClient(&redis.Options{
				Addr:     this.cfg.Addr,
				Password: this.cfg.Password,
				DB:       this.cfg.Db,
			})
			if _, _err := _r.Ping().Result(); _err != nil {
				err = _err
				// fmt.Println("redis=========", _r)
			}
		})
		return _r, nil
	} else {
		return _r, nil
	}
}
