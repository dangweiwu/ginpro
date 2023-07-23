package testtool

import (
	"{{.Module}}/internal/app"
	"{{.Module}}/internal/ctx"
	"encoding/base64"
	"github.com/gin-gonic/gin"
	"io"
	"net/http"
	"net/http/httptest"
)

type TestServer struct {
	Request  *http.Request
	Response *httptest.ResponseRecorder
	Engine   *gin.Engine
}

func NewTestServer(c *ctx.ServerContext, method string, target string, body io.Reader) *TestServer {
	a := &TestServer{}
	a.Request = httptest.NewRequest(method, target, body)
	a.Response = httptest.NewRecorder()
	gin.SetMode(gin.ReleaseMode)
	a.Engine = gin.New()

	//注册路由
	app.RegisterRoute(a.Engine, c)

	return a
}

func (this *TestServer) SetAuth(token string) *TestServer {
	this.Request.Header.Add("Authorization", token)
	return this
}

func (this *TestServer) SetBaseAuth(user, password string) *TestServer {
	base := user + ":" + password
	t := "Basic " + base64.StdEncoding.EncodeToString([]byte(base))
	this.Request.Header.Add("Authorization", t)
	return this
}

func (this *TestServer) Do() *TestServer {
	this.Engine.ServeHTTP(this.Response, this.Request)
	return this
}

func (this *TestServer) GetBody() string {
	return this.Response.Body.String()
}
func (this *TestServer) GetCode() int {
	return this.Response.Code
}
