package app

import "{{.Module}}/internal/serctx"

var Tables = []interface{}{
	
}

func Regdb(serCtx *serctx.ServerContext) error {
	return serCtx.Db.Set("gorm:ble_options", "ENGINE=InnoDB DEFAULT CHARSET=utf8").AutoMigrate(Tables...)
}
