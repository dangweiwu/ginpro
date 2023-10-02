package metric

import "github.com/dangweiwu/ginpro/pkg/syncx"

// A VectorOpts is a general configuration.
var (
	enabled syncx.AtomicBool
)

type VectorOpts struct {
	Namespace string
	Subsystem string
	Name      string
	Help      string
	Labels    []string
}

func SetEnable(value bool) {
	enabled.Set(value)
}

func Enabled() bool {
	return enabled.IsTrue()
}
