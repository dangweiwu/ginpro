package yamconfig

import (
	"encoding/json"
	"errors"
	"fmt"
	"gs/pkg/utils"
	"io/ioutil"
	"os"
	"reflect"

	"github.com/creasty/defaults"
	"gopkg.in/dealancer/validate.v2"
	"gopkg.in/yaml.v3"
)

type YamlConfig struct {
	mapdata map[string]interface{}
	cfg     interface{} //指针类型
}

func NewYamlConfig(cfg interface{}) (*YamlConfig, error) {
	rfv := reflect.ValueOf(cfg)
	if err := utils.ValidatePtr(&rfv); err != nil {
		return nil, err
	}
	return &YamlConfig{cfg: cfg}, nil

}

// read and yaml unmarshal
func (this *YamlConfig) read(in string) error {
	bytes, err := ioutil.ReadFile(in)
	if err != nil {
		return err
	}

	if err := yaml.Unmarshal(bytes, &this.mapdata); err != nil {
		return err
	}
	return nil
}

// json to config obj
// use json tag not yaml
func (this *YamlConfig) jsonDecode() error {
	bytes, err := json.Marshal(this.mapdata)
	if err != nil {
		return err
	}
	// fmt.Println(string(bt), err)
	if err := json.Unmarshal(bytes, this.cfg); err != nil {
		return err
	}
	return nil
}

/*
do default
https://github.com/creasty/defaults
tag is default
*/
func (this *YamlConfig) doDefault() error {
	return defaults.Set(this.cfg)
}

/*
do valide
https://github.com/dealancer/validate
eg

	type Registration struct {
	    // Username should be between 3 and 25 characters and in alphanumeric unicode format
	    Username string `validate:"gte=3 & lte=25 & format=alnum_unicode"`

	    // Email should be empty or in the email format
	    Email string `validate:"empty=true | format=email"`

	    // Password is validated using a custom validation method
	    Password string

	    // Role should be one of "admin", "publisher", or "author"
	    Role string `validate:"one_of=admin,publisher,author"`

	    // URLs should not be empty, URLs values should be in the url format
	    URLs []string `validate:"empty=false > format=url"`

	    // Retired (pointer) should not be nil
	    Retired *bool `validate:"nil=false"`

	    // Some complex field with validation
	    Complex []map[*string]int `validate:"gte=1 & lte=2 | eq=4 > empty=false [nil=false > empty=false] > ne=0"`
	}

	func (r Registration) Validate() error {
	    if !StrongPass(r.Password) {
	        return errors.New("Password should be strong!")
	    }

	    return nil
	}
*/
func (this *YamlConfig) doValide() error {
	return validate.Validate(this.cfg)
}

func Load(configFile string, in interface{}) error {
	cfg, err := NewYamlConfig(in)
	if err != nil {
		return err
	}

	if err := cfg.read(configFile); err != nil {
		return err
	}

	if err := cfg.jsonDecode(); err != nil {
		return err
	}

	if err := cfg.doDefault(); err != nil {
		return err
	}

	if err := cfg.doValide(); err != nil {
		return err
	}
	return nil
}

func MustLoad(configFile string, in interface{}) {
	if err := Load(configFile, in); err != nil {
		if errors.Is(err, os.ErrNotExist) {
			fmt.Println("缺少配置文件")
			os.Exit(1)
		} else {
			fmt.Println("读取配置文件失败")
			fmt.Println(err.Error())
			os.Exit(1)
		}
	}
}
