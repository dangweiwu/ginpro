package api_test

import (
	"{{.Module}}/internal/ctx"
	"{{.Module}}/internal/testtool"
	"{{.Module}}/internal/testtool/testctx"
	"testing"
)

var SerCtx *ctx.ServerContext
var TestCtx *testctx.TestContext

func TestMain(m *testing.M) {

	config := testtool.NewTestConfig()
	//单元测试并发执行 防止数据库端口冲突
	config.Mysql.Host = "127.0.0.1:3308"
	ctx, err := testctx.NewTestContext(config)
	defer func() {
		ctx.Close()
	}()
	if err != nil {
		panic(err)
	}

	SerCtx, err = ctx.GetServerCtx()
	TestCtx = ctx
	if err != nil {
		panic(err)
	}
	m.Run()
	ctx.Close()
}
