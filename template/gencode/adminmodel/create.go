package adminmodel

import "github.com/dangweiwu/pkg/dbtype"

// @create
type AdminForm struct {
	dbtype.BaseForm
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required" extensions:"x-name=账号,x-value=admin,x-valid=required"`
	Phone        string `json:"phone" gorm:"type:varchar(50);comment:电话" binding:"max=11" extensions:"x-name=手机号,x-value=12345678912,x-valid=len:1"`
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100" extensions:"x-name=姓名,x-value=张三,x-valid=max:100"`
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1" extensions:"x-name=状态,x-value=1,x-valid=oneof:'0' '1'"` //状态 0无效|1有效 0时会把当前在线人员踢下线
	Password     string `json:"password" gorm:"size:100;not null;comment:密码" binding:"max=100,required" extensions:"x-name=密码,x-value=123456,x-valid=required"`
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=备注,x-value=,x-valid=max=300"`
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email" extensions:"x-name=Email,x-value=2@qq.com,x-valid=omitempty|empty"`
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1" extensions:"x-name=是否超级管理员,x-value:1,x-valid=oneof='0''1'"` // 是否超级管理员 1:是 0:否
}

func (AdminForm) TableName() string {
	return "admin"
}
