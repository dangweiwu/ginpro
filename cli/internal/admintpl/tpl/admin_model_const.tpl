package adminmodel
import "strconv"

const (
	RedisPre       string = "admin:"
)

func GetAdminId(id int) string {
	return RedisPre + strconv.Itoa(id)
}
