package utils

import (
	"bytes"
	"unicode"
)
func Camel2Case(name string) string {
	buffer := bytes.NewBufferString("")
	for i, r := range name {
		if unicode.IsUpper(r) {
			if i != 0 {
				buffer.WriteString("_")
			}
			buffer.WriteString(string(unicode.ToLower(r)))
		} else {
			buffer.WriteString(string(i))
		}
	}
	return buffer.String()
}

func MapKeyCase(r map[string]string) map[string]string{
	m:=map[string]string{}
	for k,v:=range r{
		m[Camel2Case(k)] = v
	}
	return m
}