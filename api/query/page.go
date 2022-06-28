package query

import "github.com/gin-gonic/gin"

const (
	LIMIT   = "limit"
	TOTAL   = "total"
	CURRENT = "current"
	//DB_ORDER     = "created_at desc"
)

var (
	LIMIT_CONF   = 10
	CURRENT_CONF = 1
)

type Page struct {
	Limit   int `form:"limit"`   // 每页条数
	Current int `form:"current"` //当前页数
	Total   int //总数
}

type PageData struct {
	Data interface{}
	Page *Page
}

//解析page 选项
func ParsePage(ctx *gin.Context) *Page {
	page := &Page{}
	ctx.ShouldBindQuery(page)

	if page.Limit == 0 {
		page.Limit = LIMIT_CONF
	}
	if page.Current == 0 {
		page.Current = CURRENT_CONF
	}
	return page
}
