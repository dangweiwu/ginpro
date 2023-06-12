package adminmodel

import (
	"gs/pkg/dbtype"
)

type AdminPo struct {
	dbtype.Base
	Account      string `json:"account" gorm:"type:varchar(50);unique;comment:账号" binding:"required"`                     //账号
	Phone        string `json:"phone" gorm:"type:varchar(50);comment:电话" binding:"max=11"`                                //手机号 只进行11位校验
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
