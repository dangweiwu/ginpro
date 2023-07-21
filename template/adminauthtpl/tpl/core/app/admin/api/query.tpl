package api

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/ctx"
    "{{.Module}}/internal/pkg/tracex"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
	"{{.Host}}/api/query"
    "go.opentelemetry.io/otel/trace"
)

type AdminQuery struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAdminQuery(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AdminQuery{hd.NewHd(c), c, sc}
}

// @tags    系统用户
// @summary 查询用户
// @x-group		{"key":"adminuser","inorder":4}
// @router  /api/admin [get]
// @param   Authorization header   string  true  " " extensions(x-name=鉴权,x-value=[TOKEN])
// @param   limit query    string          false " "  extensions(x-name=分页条数,x-value=10)
// @param   current query    string        false " "  extensions(x-name=页码,x-value=1)
// @param   account query    string        false " "  extensions(x-name=账号,x-value=admin)
// @param   phone   query    string        false " "  extensions(x-name=手机号,x-value=123)
// @param   email   query    string        false " "   extensions(x-name=Email,x-value=2)
// @param   name    query    string        false " "  extensions(x-name=姓名,x-value=)
// @success 200     {object} adminmodel.AdminVo " "
func (this *AdminQuery) Do() error {
	data, err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(data)
		return nil
	}
}

var QueryRule = map[string]string{
	"account": "like",
	"phone":   "like",
	"email":   "like",
	"name":    "like",
}

func (this *AdminQuery) Query() (interface{}, error) {
	var span trace.Span
	traceOk := this.sc.OpenTrace.IsTrue()
	if traceOk {
		span = tracex.Start(this.ctx, this.sc.Tracer, "queryDb")
		defer span.End()
	}
	po := &adminmodel.AdminVo{}
	pos := []adminmodel.AdminVo{}
	q := query.NewQuery(this.ctx, this.sc.Db, QueryRule, po, &pos)
	/*
	q.SetWhere(func(db *gorm.DB) (r *gorm.DB) {
		db = db.Preload("RolePo")
		return q.Where(db)
	})
	*/
	if traceOk {
		span.AddEvent("dbstart")
	}
	return q.Do()
}
