package dbtype

import (
	"database/sql/driver"
	"encoding/json"
	"errors"
	"fmt"
	"gorm.io/gorm"
	"gorm.io/gorm/schema"
)

type ListType interface {
	string | int | int64
}

type List[T ListType] []T

func (this *List[T]) Scan(value interface{}) error {
	if value == nil {
		*this = []T{}
		return nil
	}
	var bts []byte
	switch v := value.(type) {
	case []byte:
		if len(v) == 0 {
			*this = []T{}
			return nil
		} else {
			bts = v
		}
	case string:
		if v == "" {
			*this = []T{}
			return nil
		} else {
			bts = []byte(v)
		}
	default:
		return errors.New(fmt.Sprint("Failed to unmarshal JSONB value:", value))
	}
	return json.Unmarshal(bts, this)
}

func (this List[T]) Value() (driver.Value, error) {
	if this == nil {
		return []byte("[]"), nil
	}
	return json.Marshal(this)
}

func (List[T]) GormDataType() string {
	return "string"
}

func (List[T]) GormDBDataType(db *gorm.DB, field *schema.Field) string {
	switch db.Dialector.Name() {
	case "sqlite":
		return "JSON"
	case "mysql":
		return "JSON"
	case "postgres":
		return "JSONB"
	}
	return ""
}
