package mymodel

import (
	"{{.Host}}/pkg/dbtype"
)

// my info
type MyInfo struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required" extensions:"x-name=账号"`
	Phone        string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11" extensions:"x-name=电话"`
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100" extensions:"x-name=姓名"`
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=备注"`
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email" binding:"omitempty,email" extensions:"x-name=Email"`
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1" extensions:"x-name=是否超管"`
    Role         string `json:"role" gorm:"size:100;not null;index;comment:角色" extension:"x-name=角色,x-valid=max=10,x-value=admin"` //角色代码
}

func (MyInfo) TableName() string {
	return "admin"
}

// my update
type MyForm struct {
	//dbtype.Base
	ID    int64  `json:"id" gorm:"primaryKey" swaggerignore:"true" `
	Phone string `json:"phone" gorm:"type:varchar(50);unique;comment:电话" binding:"max=11"  extensions:"x-name=phone,x-value=12345678901,x-valid=mx:11"`
	Name  string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100" extensions:"x-name=姓名,x-value=张三"`
	Memo  string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=备注,x-value='',x-valid=max:300"`
	Email string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email" extensions:"x-name=Email,x-value=2@qq.com,x-valid=omitempty,email"`
}

func (MyForm) TableName() string {
	return "admin"
}

//log form
type LoginForm struct {
	Account  string `json:"account" binging:"required"  extensions:"x-name=账号,x-value=admin,x-valid=required"`
	Password string `json:"password" binging:"required" extensions:"x-name=密码,x-value=12345,x-valid=required"`
}

// 登陆返回token
type LogRep struct {
	AccessToken  string `json:"access_token" extensions:"x-name=鉴权token"`
	RefreshAt    int64  `json:"refresh_at" extensions:"x-name=刷新时间点"`
	RefreshToken string `json:"refresh_token" extensions:"x-name=刷新token"`
}

//刷新用token
type RefreshTokeForm struct {
	RefreshToken string `json:"refresh_token" binding:"required" extensions:"x-name=刷新token,x-valid=required"`
}

//修改密码
type PasswordForm struct {
	Password    string `json:"password" binding:"required" extensions:"x-name=原始密码,x-valid=required"`
	NewPassword string `json:"new_password" binding:"required" extensions:"x-name=新密码,x-valid=required"`
}

