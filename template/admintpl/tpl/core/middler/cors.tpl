package middler

import (
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	"time"
)

func Cors() gin.HandlerFunc {
	config := cors.DefaultConfig()
	config.AllowMethods = []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD"}
	config.AllowHeaders = []string{"Origin", "Content-Length", "Content-Type", "*"}
	config.AllowCredentials = false
	config.AllowOrigins = []string{"*"}
	config.ExposeHeaders = []string{"token"}
	config.MaxAge = time.Hour * 24
	return cors.New(config)
}
