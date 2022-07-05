package hd

import (
	"errors"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetId(ctx *gin.Context) (int64, error) {
	_id, has := ctx.Params.Get("id")
	if !has {
		return 0, errors.New("缺少ID")
	}
	id, err := strconv.Atoi(_id)
	if err != nil {
		return 0, errors.New("无效ID")
	}
	return int64(id), nil
}
