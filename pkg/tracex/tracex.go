package tracex

import (
	"context"
	"fmt"
	"github.com/gin-gonic/gin"
	"go.opentelemetry.io/otel"
	"go.opentelemetry.io/otel/attribute"
	"go.opentelemetry.io/otel/codes"
	semconv "go.opentelemetry.io/otel/semconv/v1.17.0"
	"go.opentelemetry.io/otel/semconv/v1.17.0/httpconv"
	"go.opentelemetry.io/otel/trace"
	"github.com/dangweiwu/pkg/syncx"
	"net/http"
)

/*
trace start
*/

type Filter func(*http.Request) bool
type Tracex struct {
	name string
	e    *syncx.AtomicBool
	t    trace.Tracer
}

func NewTrace(name string) *Tracex {
	a := &Tracex{
		name: name,
		e:    syncx.NewAtomicBool(),
		t:    otel.Tracer(name),
	}
	return a
}

func (this *Tracex) IsEnable() bool {
	return this.e.IsTrue()
}

func (this *Tracex) SetEnable(v bool) {
	this.e.Set(v)
}

func (this *Tracex) GinStart(ctx *gin.Context, spanName string) *Spanx {
	if this.e.IsTrue() {
		_tx, _span := this.t.Start(ctx.Request.Context(), spanName)
		ctx.Request = ctx.Request.WithContext(_tx)
		return &Spanx{_span}

	} else {
		return nil
	}
}

func (this *Tracex) Start(ctx context.Context, spanName string) (context.Context, *Spanx) {
	if this.e.IsTrue() {
		_tx, _span := this.t.Start(ctx, spanName)
		return _tx, &Spanx{_span}
	} else {
		return ctx, nil
	}
}

func (this *Tracex) GinMiddler(filters ...Filter) gin.HandlerFunc {
	return func(c *gin.Context) {
		if !this.IsEnable() {
			return
		}
		for _, f := range filters {
			if !f(c.Request) {
				c.Next()
				return
			}
		}
		spanName := c.FullPath()
		if spanName == "" {
			spanName = fmt.Sprintf("HTTP %s route not found", c.Request.Method)
		}

		span := this.GinStart(c, spanName)
		defer span.End()
		c.Next()

		status := c.Writer.Status()
		span.SetStatus(httpconv.ServerStatus(status))
		if status > 0 {
			span.SetAttributes(semconv.HTTPStatusCode(status))
		}
		if len(c.Errors) > 0 {
			span.SetAttributes(attribute.String("gin.errors", c.Errors.String()))
		}

	}
}

type Spanx struct {
	s trace.Span
}

func (this *Spanx) End() {
	if this != nil {
		this.s.End()
	}
}

func (this *Spanx) AddEvent(v string) {
	if this != nil {
		this.s.AddEvent(v)
	}
}

func (this *Spanx) SetStatus(code codes.Code, description string) {
	if this != nil {
		this.s.SetStatus(code, description)
	}
}

func (this *Spanx) SetAttributes(kv ...attribute.KeyValue) {
	if this != nil {
		this.s.SetAttributes(kv...)
	}
}
