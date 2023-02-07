package pkg

import (
	"crypto/sha256"
	"fmt"
	"io"
)

func GetPassword(x string) string {
	hasher := sha256.New()
	io.WriteString(hasher, x)
	io.WriteString(hasher, "xx_2020/11/8@#!!@#$")
	return fmt.Sprintf("%x", hasher.Sum(nil))
}
