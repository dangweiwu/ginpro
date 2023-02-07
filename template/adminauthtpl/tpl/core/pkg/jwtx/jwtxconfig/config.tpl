package jwtconfig

type JwtConfig struct {
	Secret string `validate:"empty=false"`
	Exp    int64  `validate:"ne=0"`
}
