package dbtype

import (
	"database/sql/driver"
	"encoding/json"
	"errors"
)

type ListString []string

//
//数据库独处
func (this *ListString) Scan(value interface{}) error {
	switch value.(type) {
	case string:
		d := value.(string)
		err:=json.Unmarshal([]byte(d),this)
		if err !=nil{
			return err
		}
	default:
		return errors.New("类型错误")

	}
	return nil

}

//
//数据库读出
func (this ListString) Value() (driver.Value, error) {
	if this == nil {
		return "[]", nil
	}
	d, _ := json.Marshal(this)
	return string(d), nil
}