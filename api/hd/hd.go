package hd

import (
	"github.com/gin-gonic/gin"
)

type Hd struct {
	ctx *gin.Context
}

func NewHd(ctx *gin.Context) *Hd {
	return &Hd{ctx}
}

// 获取ID
func (this *Hd) GetId() (int64, error) {
	return GetId(this.ctx)
}

func (this *Hd) ErrCode(data string, msg string) ErrResponse {
	return ErrCode(data, msg)
}

func (this *Hd) ErrMsg(data string, msg string) ErrResponse {
	return ErrMsg(data, msg)
}

func (this *Hd) Bind(po interface{}) error {
	return Bind(this.ctx, po)
}

func (this *Hd) Rep(data interface{}) {
	Rep(this.ctx, data)
}

func (this *Hd) RepOk() {
	RepOk(this.ctx)
}
