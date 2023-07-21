package sysmodel

type SysVo struct {
	RunTime    string `json:"run_time"`
	StartTime  string `json:"start_time"`
	OpenTrace  string `json:"open_trace" binding:"onof=0 1" extensions:"x-name=启动链路追踪,x-value=1,x-valid=oneof=0 1"`
	OpenMetric string `json:"open_metric" binding:"oneof=0 1" extensions:"x-name=启动指标采集,x-value=1,x-valid=oneof=0 1"`
}

func (SysVo) TableName() string {
	return "sys"
}
