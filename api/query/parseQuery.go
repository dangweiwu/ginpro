package query

import "github.com/gin-gonic/gin"

func ParseQuery(ctx *gin.Context, rule map[string]string) (likeq, q map[string]string) {
	likeq = map[string]string{}
	q = map[string]string{}
	for k, v := range rule {
		if v == "like" {
			if d, _ := ctx.GetQuery(k); d != "" {
				likeq[k] = d
			}

		} else {
			if d, _ := ctx.GetQuery(k); d != "" {
				q[k] = d
			}
		}
	}
	return
}
