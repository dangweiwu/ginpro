package authmodel

import "{{.Host}}/pkg/dbtype"

type AuthPo struct {
	dbtype.Base
	Name     string `json:"name" gorm:"size:100;comment:名称" binding:"max=100"`
	Code     string `json:"code" gorm:"size:100;not null;unique;comment:权限ID" binding:"required,max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序" binding:""`
	Api      string `json:"api" gorm:"size:200;default:'';comment:接口" binding:"max=200"`
	Method   string `json:"method" gorm:"size:10;default:'';comment:请求方式" binding:"max=50"`
	Kind     string `json:"kind" gorm:"type:enum('1','0');default:'0';comment:0 api 1 菜单" binding:"oneof=0 1"`
	ParentId int    `json:"parent_id" gorm:"default:0;not null;comment:上级菜单ID"` //父类ID
	//Children []AuthPo `json:"children" gorm:"foreignkey:ParentId"`
}

func (AuthPo) TableName() string {
	return "auth"
}

type AuthForm struct {
	dbtype.Base
	Name     string `json:"name" gorm:"size:100;comment:名称" binding:"max=100"`
	Code     string `json:"code" gorm:"size:100;not null;unique;comment:权限ID" binding:"required,max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序" binding:""`
	Api      string `json:"api" gorm:"size:200;default:'';comment:接口" binding:"max=200"`
	Method   string `json:"method" gorm:"size:10;default:'';comment:请求方式" binding:"max=50"`
	Kind     string `json:"kind" gorm:"type:enum('1','0');default:'0';comment:0 api 1 菜单" binding:"oneof=0 1"`
	ParentId int    `json:"parent_id" gorm:"default:0;not null;comment:上级菜单ID"` //父类ID
}

func (AuthForm) TableName() string {
	return "auth"
}

type AuthUpdateForm struct {
	dbtype.Base
	Name     string `json:"name" gorm:"size:100;comment:名称" binding:"max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序" binding:""`
	Api      string `json:"api" gorm:"size:200;default:'';comment:接口" binding:"max=200"`
	Method   string `json:"method" gorm:"size:10;default:'';comment:请求方式" binding:"max=50"`
	Kind     string `json:"kind" gorm:"type:enum('1','0');default:'0';comment:0 api 1 菜单" binding:"oneof=0 1"`
	ParentId int    `json:"parent_id" gorm:"default:0;not null;comment:上级菜单ID"` //父类ID
}

func (AuthUpdateForm) TableName() string {
	return "auth"
}
