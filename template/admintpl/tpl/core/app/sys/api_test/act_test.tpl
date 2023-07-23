package api_test

import (
	"{{.Module}}/internal/app/sys/sysmodel"
	"{{.Module}}/internal/testtool"
	"bytes"
	"encoding/json"
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestAct(t *testing.T) {

	form := &sysmodel.SysActForm{}
	form.Act = "1"
	form.Name = "trace"
	body, _ := json.Marshal(form)

	ser := testtool.NewTestServer(SerCtx, "PUT", "/api/sys", bytes.NewBuffer(body)).SetBaseAuth(Name, Password).Do()
	assert.Equal(t, 200, ser.GetCode(), "%s:%s", "act", ser.GetBody())

	form.Name = "metric"
	body, _ = json.Marshal(form)

	ser = testtool.NewTestServer(SerCtx, "PUT", "/api/sys", bytes.NewBuffer(body)).SetBaseAuth(Name, Password).Do()
	assert.Equal(t, 200, ser.GetCode(), "%s:%s", "act", ser.GetBody())
}
