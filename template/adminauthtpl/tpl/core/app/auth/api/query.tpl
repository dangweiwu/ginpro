package api

import (
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/router/irouter"
	"github.com/gin-gonic/gin"
	"{{.Host}}/api/hd"
)

type AuthQuery struct {
	*hd.Hd
	ctx *gin.Context
	sc  *ctx.ServerContext
}

func NewAuthQuery(c *gin.Context, sc *ctx.ServerContext) irouter.IHandler {
	return &AuthQuery{hd.NewHd(c), c, sc}
}

//	@tags		权限管理
//	@summary	查询权限
//	@router		/api/auth [get]
//	@x-group	{"key":"auth","inorder":4}
//	@param		Authorization	header		string				true	" "			extensions(x-name=鉴权,x-value=[TOKEN])
//	@param		kind			query		string				false	"0 按钮 1 页面"	extensions(x-name=类型,x-value=)
//	@success	200				{object}	authmodel.AuthPo	"非分页数据，数组嵌套类型"
func (this *AuthQuery) Do() error {

	data, err := this.Query()
	if err != nil {
		return err
	} else {
		this.Rep(hd.Response{data})
		return nil
	}
}

var QueryRule = map[string]string{
	"kind": "like",
}

func (this *AuthQuery) Query() (interface{}, error) {
	po := &authmodel.AuthVo{}
	pos := []authmodel.AuthVo{}

	kind := this.ctx.Query("kind")
	if kind != "" {
		if err := this.sc.Db.Model(po).Where("parent_id=0 and kind= ?", kind).Preload("Children", "kind=?", kind).Order("order_num").Find(&pos).Error; err != nil {
			return nil, err
		}
	} else {
		if err := this.sc.Db.Model(po).Where("parent_id=0").Preload("Children").Order("order_num").Find(&pos).Error; err != nil {
			return nil, err
		}
	}

	return pos, nil
}
