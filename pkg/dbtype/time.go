package dbtype

import (
	"database/sql/driver"
	"errors"
	"fmt"
	"strings"
	"time"
)

const (
	TimeFormat = "2006-01-02 15:04:05"
)

type TimeAt time.Time

func (t *TimeAt) UnmarshalJSON(data []byte) error {
	if string(data) == "null" {
		return nil
	}
	str := string(data)
	timeStr := strings.Trim(str, "\"")
	t1, err := time.Parse(TimeFormat, timeStr)
	*t = TimeAt(t1)
	return err
}

func (t TimeAt) MarshalJSON() ([]byte, error) {
	formatted := fmt.Sprintf("\"%v\"", time.Time(t).Format(TimeFormat))
	return []byte(formatted), nil
}

func (t TimeAt) Value() (driver.Value, error) {
	return time.Time(t), nil
}

func (t *TimeAt) Scan(v interface{}) error {
	switch vt := v.(type) {
	case time.Time:
		*t = TimeAt(vt)
	default:
		return errors.New("类型处理错误")
	}
	return nil
}

func (t *TimeAt) String() string {
	return fmt.Sprintf("%s", time.Time(*t).String())
}
