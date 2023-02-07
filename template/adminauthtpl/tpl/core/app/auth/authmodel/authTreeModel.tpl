package authmodel

/*
角色设置其有的权限 tree 树形控件 格式 key为Code
{children:'children', title:'title', key:'key' }
*/
type AuthTree struct {
	ID       int64      `json:"id" gorm:"primaryKey"`
	Name     string     `json:"title" gorm:"size:100;comment:名称" binding:"max=100"`
	Code     string     `json:"key" gorm:"size:100;not null;unique;comment:权限ID" binding:"required,max=100"`
	OrderNum int        `json:"order_num" gorm:"default:0;comment:排序" binding:""`
	Api      string     `json:"api" gorm:"size:200;default:'';comment:接口" binding:"max=200"`
	Method   string     `json:"method" gorm:"size:10;default:'';comment:请求方式" binding:"max=50"`
	Kind     string     `json:"kind" gorm:"type:enum('1','0');default:'0';comment:0 api 1 菜单" binding:"oneof=0 1"`
	ParentId int        `json:"parent_id" gorm:"default:0;not null;comment:上级菜单ID"` //父类ID
	Children []AuthTree `json:"children" gorm:"foreignkey:ParentId"`
}

func (AuthTree) TableName() string {
	return "auth"
}
