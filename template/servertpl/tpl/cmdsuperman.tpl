package cmd

import (
	"{{.Module}}/internal/app/admin/adminmodel"
	"{{.Module}}/internal/config"
	"{{.Module}}/internal/pkg"
	"errors"
	errs "github.com/pkg/errors"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"gs/pkg/mysqlx"
	"log"
)

/*
创建超级用户
*/

type Superman struct {
	db  *gorm.DB
	cfg config.Config
}

func NewSuperman(cfg config.Config) *Superman {
	//初始化数据库
	a := &Superman{}
	if d, err := mysqlx.NewDb(cfg.Mysql).GetDb(); err != nil {
		panic(err)
	} else {
		d.Logger = logger.Default.LogMode(logger.Info)
		d.Debug()
		a.db = d

	}
	a.cfg = cfg

	return a
}

func (this *Superman) CreateSuperman() error {
	if !this.cfg.Admin.InitAdmin {
		log.Println("禁止初始化超级管理员")
		return errors.New("forbit")
	}
	po := &adminmodel.AdminPo{}

	ct := int64(0)
	this.db.Where("account=?", "admin").Take(po).Count(&ct)
	po.Password = pkg.GetPassword(this.cfg.Admin.RawPassword)
	if ct == 0 {
		po.Name = "超级管理员"
		po.Account = "admin"
		po.IsSuperAdmin = "1"
		if r := this.db.Create(po); r.Error != nil {
			return errs.Wrap(r.Error, "创建用户失败")
		}
	} else {
		if r := this.db.Where("account=?", "admin").Select("password").Updates(po); r.Error != nil {
			return errs.Wrap(r.Error, "更新用户失败")
		}
	}
	return nil
}
