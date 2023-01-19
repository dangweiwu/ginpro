package adminmodel

import (
	"gs/pkg/dbtype"
)

type AdminPostPo struct {
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`                     //账号
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`                         //手机号 只进行11位校验
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`                    //名称
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"`      //状态 1 close 0 open
	Password     string `json:"password" gorm:"size:100;not null;comment:密码" binding:"max=100,required"`                  //密码
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`                                       //备注
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`           //email 非空则进行email有效性校验
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"` // 是否超级管理员 1:是 0:否
}

func (AdminPostPo) TableName() string {
	return "admin"
}

type AdminPo struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`                     //账号
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`                         //手机号 只进行11位校验
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`                    //名称
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"`      //状态 1 close 0 open
	Password     string `json:"password" gorm:"size:100;not null;comment:密码" binding:"max=100,required"`                  //密码
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`                                       //备注
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`           //email 非空则进行email有效性校验
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"` // 是否超级管理员 1:是 0:否
}

func (AdminPo) TableName() string {
	return "admin"
}

// get用 不带password
type AdminPo1 struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"` //1 close 0 open
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (AdminPo1) TableName() string {
	return "admin"
}

// put用
type AdminPo2 struct {
	dbtype.Base
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`                         //手机号
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`                    //名称
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0无效|1有效'" binding:"oneof=0 1"`       //状态 0无效|1有效 0时会把当前在线人员踢下线
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`                                       //备注
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`           //Email
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"` //是否超级管理员
}

func (AdminPo2) TableName() string {
	return "admin"
}

// my get info
type AdminPo3 struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (AdminPo3) TableName() string {
	return "admin"
}

// my put
type AdminPo4 struct {
	//dbtype.Base
	ID    int64  `json:"id" gorm:"primaryKey" swaggerignore:"true" `
	Phone string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`               //电话
	Name  string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`          //姓名
	Memo  string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`                             //备注
	Email string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"` //email
}

func (AdminPo4) TableName() string {
	return "admin"
}

// 登陆返回token
type LogRep struct {
	AccessToken  string `json:"access_token"`  //Authorization 鉴权token
	RefreshAt    int64  `json:"refresh_at"`    //刷新时间
	RefreshToken string `json:"refresh_token"` //刷新token
}
