package fullurl

import (
	"github.com/gin-gonic/gin"
	"strings"
	"sync"
)

/*
树结构展示部分
不需要进行鉴权的地址
与auth保持一致
*/

var skipurl = map[string]struct{}{
	"/api/allurl":        {},
	"/api/login":         {},
	"/api/my":            {},
	"/api/logout":        {},
	"/api/auth/tree":     {},
	"/api/my/password":   {},
	"/api/token/refresh": {},
}

var once sync.Once
var FullUrl *fullUrl

type fullUrl struct {
	sync.RWMutex
	Url []string
	e   *gin.Engine
}

// 单例模式
func NewFullUrl() *fullUrl {
	if FullUrl == nil {
		once.Do(func() {
			if FullUrl == nil {
				FullUrl = &fullUrl{}
			}
		})
	}
	return FullUrl
}

func (this *fullUrl) GetUrl() []string {
	this.RLock()
	defer this.RUnlock()
	return this.Url
}

func (this *fullUrl) InitUrl(e *gin.Engine) {
	this.Lock()
	defer this.Unlock()
	a := e.Routes()

	uniqueRole := map[string]struct{}{}
	this.Url = []string{}
	for _, v := range a {
		if strings.Index(v.Path, "/api") == 0 {
			if _, has := uniqueRole[v.Path]; !has {
				if _, has := skipurl[v.Path]; !has {
					this.Url = append(this.Url, v.Path)
				}
				uniqueRole[v.Path] = struct{}{}
			}
		}
	}
}
