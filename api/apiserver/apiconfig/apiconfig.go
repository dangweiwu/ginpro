package apiconfig

type ApiConfig struct {
	Host       string `default:"127.0.0.1:8000"`
	OpenGinLog bool   `default:"false"`
	ViewDir    string `default:"./view"`
	CertFile   string
	KeyFile    string
}
