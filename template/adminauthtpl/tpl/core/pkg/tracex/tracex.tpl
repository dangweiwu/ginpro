package tracex

import (
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel/trace"
)

/*
trace start
*/
func Start(ctx *gin.Context, tc trace.Tracer, spanName string) trace.Span {
	_tx, _span := tc.Start(ctx.Request.Context(), spanName)
	ctx.Request = ctx.Request.WithContext(_tx)
	return _span
}

