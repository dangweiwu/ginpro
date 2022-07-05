package adminmodel

type LoginForm struct {
	Account  string `binding:"required"`
	Password string `binging:"required"`
}
