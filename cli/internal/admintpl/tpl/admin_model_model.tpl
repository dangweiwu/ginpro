package adminmodel

import (
	"gs/pkg/dbtype"
)

type AdminPo struct {
	dbtype.Base
	Account      string `gorm:"type:varchar(50);unique;comment:账号" binding:"required"`
	Phone        string `gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Status       string `gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"` //1 close 0 open
	Password     string `gorm:"size:100;not null;comment:密码" binding:"max=100;required"`
	Memo         string `gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (AdminPo) TableName() string {
	return "admin"
}

//get用 不带password
type AdminPo1 struct {
	dbtype.Base
	Account      string `gorm:"type:varchar(50);unique;comment:账号" binding:"required"`
	Phone        string `gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Status       string `gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"` //1 close 0 open
	Memo         string `gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (AdminPo1) TableName() string {
	return "admin"
}

//put用
type AdminPo2 struct {
	dbtype.Base
	Phone        string `gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Status       string `gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"` //1 close 0 open
	Memo         string `gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (AdminPo2) TableName() string {
	return "admin"
}

//my get info
type AdminPo3 struct {
	dbtype.Base
	Phone        string `gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Memo         string `gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (AdminPo3) TableName() string {
	return "admin"
}

//my put
type AdminPo4 struct {
	dbtype.Base
	Phone string `gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name  string `gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Memo  string `gorm:"type:text;comment:备注" binding:"max=300"`
	Email string `gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
}

func (AdminPo4) TableName() string {
	return "admin"
}