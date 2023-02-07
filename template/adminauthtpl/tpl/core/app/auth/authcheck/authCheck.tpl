package authcheck

import (
	"github.com/casbin/casbin/v2"
	"github.com/casbin/casbin/v2/model"
	"gorm.io/gorm"
)

var mymodel = `
[request_definition]
r = role, api, method

[policy_definition]
p = role, api, method

[matchers]
m = r.role == p.role && keyMatch2(r.api,p.api) && r.method==p.method

[policy_effect]
e = some(where (p.eft == allow))
`

type AuthCheck struct {
	e *casbin.Enforcer
}

func NewAuthCheckout(db *gorm.DB) (*AuthCheck, error) {
	policy := NewAdapter(db)
	m, err := model.NewModelFromString(mymodel)
	if err != nil {
		return nil, err
	}
	e, err := casbin.NewEnforcer(m, policy)
	if err != nil {
		return nil, err
	}
	return &AuthCheck{e}, nil
}

func (this *AuthCheck) Check(rolecode, api, method string) (bool, error) {
	return this.e.Enforce(rolecode, api, method)
}

func (this *AuthCheck) LoadPolicy() {
	this.e.LoadPolicy()
}
