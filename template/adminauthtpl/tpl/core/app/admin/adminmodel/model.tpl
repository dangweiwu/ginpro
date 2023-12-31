package adminmodel

import (
	"{{.Host}}/pkg/dbtype"
)
type AdminPo struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`                     //账号
	Phone        string `json:"phone" gorm:"type:varchar(50);comment:电话" binding:"max=11"`                         //手机号 只进行11位校验
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100"`                    //名称
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1"`      //状态 1 close 0 open
	Password     string `json:"password" gorm:"size:100;not null;comment:密码" binding:"max=100,required"`                  //密码
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"`                                       //备注
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"`           //email 非空则进行email有效性校验
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"` // 是否超级管理员 1:是 0:否
	Role         string `json:"role" gorm:"size:100;not null;index;comment:角色"`                                           //角色
}

func (AdminPo) TableName() string {
	return "admin"
}



type AdminForm struct {
    dbtype.BaseForm
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required" extensions:"x-name=账号,x-value=admin,x-valid=required"`   //账号
	Phone        string `json:"phone" gorm:"type:varchar(50);comment:电话" binding:"max=11" extensions:"x-name=手机号,x-value=12345678912,x-valid=len:1"`   //手机号 只进行11位校验
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100" extensions:"x-name=姓名,x-value=张三,x-valid=max:100"`     //名称
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1" extensions:"x-name=状态,x-value=1,x-valid=oneof:'0' '1'"`  //状态 1 close 0 open
	Password     string `json:"password" gorm:"size:100;not null;comment:密码" binding:"max=100,required" extensions:"x-name=密码,x-value=123456,x-valid=required"`         //密码
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300"  extensions:"x-name=备注,x-value=,x-valid=max=300"`              //备注
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email" extensions:"x-name=Email,x-value=2@qq.com,x-valid=omitempty|empty"`   //email 非空则进行email有效性校验
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1"  extensions:"x-name=是否超级管理员,x-value:1,x-valid=oneof='0''1'"` // 是否超级管理员 1:是 0:否
	Role         string `json:"role" gorm:"size:100;not null;index;comment:角色" binding:"max=100" extension:"x-name=角色,x-valid=max=10,x-value=admin"`                         //角色
}

func (AdminForm) TableName() string {
	return "admin"
}



// get用 不带password
type AdminVo struct {
	dbtype.Base
	Account      string            `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required" extensions:"x-name=账号,x-value=admin"`
	Phone        string            `json:"phone" gorm:"type:varchar(50);comment:电话" binding:"max=11" extensions:"x-name=手机号,x-value=12345678912,x-valid=len:1"`
	Name         string            `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100" extensions:"x-name=姓名,x-value=张三,x-valid=max:100"`
	Status       string            `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0:无效|1有效'" binding:"oneof=0 1" extensions:"x-name=状态,x-value='1',x-valid=oneof:'0' '1'"`
	Memo         string            `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=备注,x-value='',x-valid=max=300"`
	Email        string            `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email" extensions:"x-name=Email,x-value=2@qq.com"`
	IsSuperAdmin string            `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1" extensions:"x-name=是否超级管理员,x-value:'1',x-valid=oneof='0''1'"`
	Role         string            `json:"role" gorm:"size:100;not null;index;comment:角色" binding:"max=100" extensions:"x-name:角色,x-value:admin,x-valid:max=100"`
}

func (AdminVo) TableName() string {
	return "admin"
}

// update用
type AdminUpdateForm struct {
	dbtype.Base
	Phone        string `json:"phone" gorm:"type:varchar(50);comment:电话" binding:"max=11" extensions:"x-name=手机号,x-value=12345678912,x-valid=len:1"`  //手机号
	Name         string `json:"name" gorm:"size:100;not null;default:'';comment:名称" binding:"max=100" extensions:"x-name=姓名,x-value=张三,x-valid=max:100"`  //名称
	Status       string `json:"status" gorm:"type:enum('0','1');default:'1';comment:'0无效|1有效'" binding:"oneof=0 1"  extensions:"x-name=状态,x-value=1,x-valid=oneof:'0' '1'"`  //状态 0无效|1有效 0时会把当前在线人员踢下线
	Memo         string `json:"memo" gorm:"type:text;comment:备注" binding:"max=300" extensions:"x-name=备注,x-value='',x-valid=max=300"`  //备注
	Email        string `json:"email" gorm:"type:varchar(100);default:'';comment:邮件" binding:"omitempty,email"  extensions:"x-name=Email,x-value=2@qq.com,x-valid=omitempty|empty"`  //Email
	IsSuperAdmin string `json:"is_super_admin" gorm:"type:enum('1','0');default:'0';comment:是否超级管理员" binding:"oneof=0 1" extensions:"x-name=是否超级管理员,x-value:1,x-valid=oneof='0''1'"` //是否超级管理员
	Role         string `json:"role" gorm:"size:100;not null;index;comment:角色" binding:"max=100" extensions:"x-name:角色,x-value:admin,x-valid:max=100"`   //角色
}

func (AdminUpdateForm) TableName() string {
	return "admin"
}
