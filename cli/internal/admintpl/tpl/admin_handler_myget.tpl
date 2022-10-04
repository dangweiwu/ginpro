package handler

import (

	"errors"
	"gs/api/hd"

	"{{.Module}}/internal/router/irouter"
    "{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/pkg/jwtx"
	"{{.Module}}/internal/serctx"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

/*
获取我的信息
*/
type MyInfo struct {
	*hd.Hd
	ctx    *gin.Context
	sc *serctx.ServerContext
}

func NewMyInfo(ctx *gin.Context, sc *serctx.ServerContext) irouter.IHandler {
	return &MyInfo{hd.NewHd(ctx),ctx, sc}
}

func (this *MyInfo) Do() error {

	uid, err := jwtx.GetUid(this.ctx)
	if err != nil {
		return err
	}

	po := &adminmodel.AdminPo3{}
	if r := this.sc.Db.Model(po).Where("id = ?", uid).Take(po); r.Error != nil {
		if r.Error == gorm.ErrRecordNotFound {
			return errors.New("记录不存在")
		} else {
			return r.Error
		}
	}
	this.Rep( po)
	return nil
}