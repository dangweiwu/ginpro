package mymodel

import (
	"{{.Host}}/pkg/dbtype"
)

// my info
type MyInfo struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"`
}

func (MyInfo) TableName() string {
	return "admin"
}

// my update
type MyForm struct {
	//dbtype.Base
	ID    int64  `json:"id" gorm:"primaryKey" swaggerignore:"true" `
	Phone string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"`               //电话
	Name  string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`          //姓名
	Memo  string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`                             //备注
	Email string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"` //email
}

func (MyForm) TableName() string {
	return "admin"
}

//log form
type LoginForm struct {
	Account  string `json:"account" binging:"required"`  //账号
	Password string `json:"password" binging:"required"` //密码
}

// 登陆返回token
type LogRep struct {
	AccessToken  string `json:"access_token"`  //Authorization 鉴权token
	RefreshAt    int64  `json:"refresh_at"`    //刷新时间
	RefreshToken string `json:"refresh_token"` //刷新token
}

//刷新用token
type RefreshTokeForm struct {
	RefreshToken string `json:"refresh_token" binding:"required""` //刷新token
}

//修改密码
type PasswordForm struct {
	Password    string `json:"password" binding:"required"`     //原始密码
	NewPassword string `json:"new_password" binding:"required"` //新密码
}

