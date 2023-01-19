package app

import "{{.Module}}/internal/serctx"

var Tables = []interface{}{
	
}

func Regdb(sc *serctx.ServerContext) error {
	return sc.Db.Set("gorm:ble_options", "ENGINE=InnoDB DEFAULT CHARSET=utf8").AutoMigrate(Tables...)
}
