package hd

type ErrKind string

const (
	CODE ErrKind = "code" //需要映射 code映射成相关中文名 多语言需要
	MSG  ErrKind = "msg"  //无需映射 直接显示
)

type ErrResponse struct {
	Kind ErrKind `json:"kind"`
	Data string  `json:"data"`
	Msg  string  `json:"msg"`
}

func (this ErrResponse) Error() string {
	return this.Data
}

func ErrCode(data string, msg string) ErrResponse {
	return ErrResponse{CODE, data, msg}
}

func ErrMsg(data string, msg string) ErrResponse {
	return ErrResponse{MSG, data, msg}
}
