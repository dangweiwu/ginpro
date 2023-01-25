package hd

import "github.com/gin-gonic/gin"

type Response struct {
	Data interface{} `json:"data"`
}

func Rep(c *gin.Context, data interface{}) {
	c.JSON(200, data)
}

func RepOk(c *gin.Context) {
	c.JSON(200, Response{"ok"})
}
