package adminconfig

type AdminConfig struct {
	RawPassword string `default:"a123456789"`
	InitAdmin   bool   `default:"false"`
}
