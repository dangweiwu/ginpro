package sysmodel

type SysActForm struct {
	Name string `json:"name" binding:"oneof=trace metric" extensions:"x-name=名称,x-value=1,x-valid=oneof=0 1"`
	Act  string `json:"act" binding:"oneof=0 1" extensions:"x-name=动作,x-value=1,x-valid=oneof=0 1"` //0 启动 1 停止
}

func (SysActForm) TableName() string {
	return "sys"
}
