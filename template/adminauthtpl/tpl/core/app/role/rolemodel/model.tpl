package rolemodel

import (
	"{{.Host}}/pkg/dbtype"
)

type RolePo struct {
	dbtype.Base
	Code     string              `json:"code" gorm:"size:100;not null;unique;comment:角色ID" binding:"required,max=100"`
	Name     string              `json:"name" gorm:"size:100;comment:角色名称" binding:"max=100"`
	OrderNum int                 `json:"order_num" gorm:"default:0;comment:排序"`
	Status   string              `json:"status" gorm:"type:enum('0','1');default:'1';comment:状态"`
	Memo     string              `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`
	Auth     dbtype.List[string] `json:"auth" gorm:"type:text;comment:角色code列表"`
}

func (RolePo) TableName() string {
	return "role"
}

type RoleForm struct {
	Code     string `json:"code" gorm:"size:100;not null;unique;comment:角色ID" binding:"required,max=100"`
	Name     string `json:"name" gorm:"size:100;comment:角色名称" binding:"max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序"`
	Status   string `json:"status" gorm:"type:enum('0','1');default:'1';comment:状态"`
	Memo     string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`
}

func (RoleForm) TableName() string {
	return "role"
}

type RoleUpdate struct {
	ID       int64  `json:"id" gorm:"primaryKey"`
	Name     string `json:"name" gorm:"size:100;comment:角色名称" binding:"max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序"`
	Status   string `json:"status" gorm:"type:enum('0','1');default:'1';comment:状态"`
	Memo     string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`
}

func (RoleUpdate) TableName() string {
	return "role"
}

type RoleAuthForm struct {
	ID   int64               `json:"id" gorm:"primaryKey"`
	Auth dbtype.List[string] `json:"auth" gorm:"type:text;comment:角色code列表"`
}

func (RoleAuthForm) TableName() string {
	return "role"
}
