package rolemodel

import (
	"{{.Host}}/pkg/dbtype"
)

type RolePo struct {
	dbtype.Base
	Code     string              `json:"code" gorm:"size:100;not null;unique;comment:角色ID" binding:"required,max=100"  extensions:"x-name=编码"`
	Name     string              `json:"name" gorm:"size:100;comment:角色名称" binding:"max=100" extensions:"x-name=名称"`
	OrderNum int                 `json:"order_num" gorm:"default:0;comment:排序" extensions:"x-name=排序"`
	Status   string              `json:"status" gorm:"type:enum('0','1');default:'1';comment:状态" extensions:"x-name=状态"` //0 禁用 1启用
	Memo     string              `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=备注"`
	Auth     dbtype.List[string] `json:"auth" gorm:"type:text;comment:角色code列表" extensions:"x-name=权限"` //权限编码列表 eg [auth1,...]
}

func (RolePo) TableName() string {
	return "role"
}

type RoleForm struct {
	dbtype.BaseForm
	Code     string `json:"code" gorm:"size:100;not null;unique;comment:角色ID" binding:"required,max=100"   extensions:"x-name=编码,x-value= ,x-valid=required,max=100"` //全服唯一，禁止重复
	Name     string `json:"name" gorm:"size:100;comment:角色名称" binding:"max=100"   extensions:"x-name=名称,x-value= ,x-valid=max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序"   extensions:"x-name=权限名称,x-value=100000"`            //建议6位编码12顶级菜单34当前菜单56接口编码
	Status   string `json:"status" gorm:"type:enum('0','1');default:'1';comment:状态"   extensions:"x-name=状态,x-value=0"` //1 启动 0禁用
	Memo     string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"   extensions:"x-name=权限名称,x-value= ,x-valid=max=300"`
}

func (RoleForm) TableName() string {
	return "role"
}

type RoleUpdate struct {
	dbtype.BaseForm
	Name     string `json:"name" gorm:"size:100;comment:角色名称" binding:"max=100"   extensions:"x-name=名称,x-value= ,x-valid=max=100"`
	OrderNum int    `json:"order_num" gorm:"default:0;comment:排序" extensions:"x-name=权限名称,x-value=100000"`            //建议6位编码12顶级菜单34当前菜单56接口编码
	Status   string `json:"status" gorm:"type:enum('0','1');default:'1';comment:状态" extensions:"x-name=状态,x-value=0"` //1 启动 0禁用
	Memo     string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=权限名称,x-value= ,x-valid=max=300"`
}

func (RoleUpdate) TableName() string {
	return "role"
}

type RoleAuthForm struct {
	ID   int64               `json:"id" swaggerignore:"true" gorm:"primaryKey" `
	Auth dbtype.List[string] `json:"auth" gorm:"type:text;comment:角色code列表" extensions:"x-name=权限"` //权限编码列表 eg [auth1,auth2...]
}

func (RoleAuthForm) TableName() string {
	return "role"
}
