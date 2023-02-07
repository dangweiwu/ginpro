package authcheck

import (
	"{{.Module}}/internal/app/auth/authmodel"
	"{{.Module}}/internal/app/role/rolemodel"
	"errors"
	"github.com/casbin/casbin/v2/model"
	"github.com/casbin/casbin/v2/persist"
	"gorm.io/gorm"
	"{{.Host}}/pkg/dbtype"
)

/*
角色适配器
支持gorm-mysql
*/

//自定义适配器

type Adapter struct {
	db *gorm.DB
}

func NewAdapter(db *gorm.DB) *Adapter {
	return &Adapter{db}
}

// 加载规则
func (this *Adapter) LoadPolicy(model model.Model) error {
	pos := []authmodel.AuthPo{}
	rolePos := []rolemodel.RolePo{}
	if err := this.db.Where("status = '1'").Find(&rolePos).Error; err != nil {
		return err
	}

	if err := this.db.Find(&pos).Error; err != nil {
		return err
	}
	authmap := map[string]authmodel.AuthPo{}
	for _, v := range pos {
		authmap[v.Code] = v
	}
	updateRoleAuth := []rolemodel.RolePo{}
	for _, v := range rolePos {
		auths := v.Auth
		newauth := dbtype.List[string]{}
		for _, authcode := range auths {
			if authpo, has := authmap[authcode]; has {
				if authpo.Kind == "0" {
					var p = []string{"p", v.Code, authpo.Api, authpo.Method}
					persist.LoadPolicyArray(p, model)
				}
				newauth = append(newauth, authcode)
			}
		}
		if len(newauth) != len(v.Auth) {
			v.Auth = newauth
			updateRoleAuth = append(updateRoleAuth, v)
		}
	}

	_po := &rolemodel.RolePo{}
	if len(updateRoleAuth) != 0 {
		for _, role := range updateRoleAuth {
			this.db.Model(_po).Where("id=?", role.ID).Update("auth", role.Auth)
		}
	}
	return nil
}

// 保存规则
func (this *Adapter) SavePolicy(model model.Model) error {
	return nil
}

// AddPolicy 添加一个policy规则至持久层
func (a *Adapter) AddPolicy(sec string, ptype string, rule []string) error {
	return errors.New("not implemented")
}

// RemovePolicy 从持久层删除单条policy规则
func (a *Adapter) RemovePolicy(sec string, ptype string, rule []string) error {
	return errors.New("not implemented")
}

// RemoveFilteredPolicy 从持久层删除符合筛选条件的policy规则
func (a *Adapter) RemoveFilteredPolicy(sec string, ptype string, fieldIndex int, fieldValues ...string) error {
	return errors.New("not implemented")
}
