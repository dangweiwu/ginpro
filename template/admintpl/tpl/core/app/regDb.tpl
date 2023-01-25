package app

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/ctx"
)

var Tables = []interface{}{
	&adminmodel.AdminPo{},
}

func Regdb(sc *ctx.ServerContext) error {
	return sc.Db.Set("gorm:ble_options", "ENGINE=InnoDB DEFAULT CHARSET=utf8").AutoMigrate(Tables...)
}
