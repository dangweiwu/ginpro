package api_test

import (
	"{{.Module}}/internal/testtool"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestInfo(t *testing.T) {
	ser := testtool.NewTestServer(SerCtx, "GET", "/api/sys", nil).SetAuth("123456").Do()
	assert.Equal(t, 200, ser.GetCode(), "%s:%s", "act", ser.GetBody())
}
