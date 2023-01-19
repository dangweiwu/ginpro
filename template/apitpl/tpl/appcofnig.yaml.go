package tpl

type AppTplConfig struct {
	Module string

	AppName    string
	AppPackage string //自动生成

	// ObjName      string `validate:"empty=false"`
	ModelName    string
	ModelPackage string
	TableName    string

	RouterType string
	RouterUrl  string
	HasGet     bool
	HasPost    bool
	HasPut     bool
	HasDelete  bool
}
