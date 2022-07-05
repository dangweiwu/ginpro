package dbtype

import (
	"encoding/json"
	"fmt"
	"testing"
	"time"
)

type User struct {
	Name     string
	CreateAt TimeAt
}

func TestTimeAt(t *testing.T) {
	a := &User{}
	a.Name = "dang"
	a.CreateAt = TimeAt(time.Now())

	ba, err := json.Marshal(a)
	fmt.Println(string(ba), err)

	b := &User{}

	json.Unmarshal(ba, b)

	fmt.Println(a.CreateAt.String())
}
