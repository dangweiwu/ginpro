package utils

import (
	"bytes"
	"runtime"
)

/**
panic 人性化输出
eg:
defer func(){
	errs := recover()
	if errs == nil {
		return
	}
	mylog2.Log.Error("panic", zap.String("error", fmt.Sprintf("%v", errs)), zap.String("data", string(PanicTrace(2))))
}
*/
func PanicTrace(kb int) []byte {
	s := []byte("/src/runtime/panic.go")
	e := []byte("\ngoroutine ")
	line := []byte("\n")
	stack := make([]byte, kb<<10) //4KB
	length := runtime.Stack(stack, true)
	start := bytes.Index(stack, s)
	stack = stack[start:length]
	start = bytes.Index(stack, line) + 1
	stack = stack[start:]
	end := bytes.LastIndex(stack, line)
	if end != -1 {
		stack = stack[:end]
	}
	end = bytes.Index(stack, e)
	if end != -1 {
		stack = stack[:end]
	}
	stack = bytes.TrimRight(stack, "\n")
	return stack
}
