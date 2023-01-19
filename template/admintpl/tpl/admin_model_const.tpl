package adminmodel
import "strconv"


const (
	RedisPre string = "admin:"
)

func GetAdminRedisId(id int) string {
	return RedisPre + strconv.Itoa(id)
}

// redis login id
func GetAdminRedisLoginId(id int) string {
	return "lgn:" + GetAdminRedisId(id)
}

// redis login refreshtoken id
func GetAdminRedisRefreshTokenId(id int) string {
	return "rft:" + GetAdminRedisId(id)
}
