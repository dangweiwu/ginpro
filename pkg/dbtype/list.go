package dbtype

//type List []interface{}
//
//// 数据库读出
//func (this *List) Scan(value interface{}) error {
//	if value == nil {
//		*this = []interface{}{}
//		return nil
//	}
//
//	switch value.(type) {
//	case []interface{}:
//		*this = value.([]interface{})
//	case []uint8:
//		_d := value.([]uint8)
//		d := string(_d)
//		if d == "" {
//			*this = []interface{}{}
//			return nil
//		} else {
//			json.Unmarshal(_d, this)
//		}
//	}
//	return nil
//
//}
//
//// 数据库写入
//func (this List) Value() (driver.Value, error) {
//	if this == nil {
//		return "[]", nil
//	}
//	d, err := json.Marshal(this)
//	return string(d), err
//}
