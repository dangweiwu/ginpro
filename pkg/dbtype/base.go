package dbtype

import (
	"time"

	"gorm.io/gorm"
)

type Base struct {
	ID        int64  `json:"id" gorm:"primaryKey" `
	CreatedAt TimeAt `json:"created_at"`
	UpdatedAt TimeAt `json:"updated_at"`
}

func (this *Base) BeforeCreate(tx *gorm.DB) (err error) {
	this.CreatedAt = TimeAt(time.Now())
	this.UpdatedAt = TimeAt(time.Now())
	return nil
}

func (this *Base) BeforeUpdate(tx *gorm.DB) (err error) {
	this.UpdatedAt = TimeAt(time.Now())
	return
}

type BaseForm struct {
	ID        int64  `json:"-" swaggerignore:"true" gorm:"primaryKey"`
	CreatedAt TimeAt `json:"-" swaggerignore:"true"`
	UpdatedAt TimeAt `json:"-" swaggerignore:"true"`
}

func (this *BaseForm) BeforeCreate(tx *gorm.DB) (err error) {
	this.CreatedAt = TimeAt(time.Now())
	this.UpdatedAt = TimeAt(time.Now())
	return nil
}

func (this *BaseForm) BeforeUpdate(tx *gorm.DB) (err error) {
	this.UpdatedAt = TimeAt(time.Now())
	return
}


type UpdateForm struct {
	ID        int64  `json:"-" swaggerignore:"true" gorm:"primaryKey"`
	UpdatedAt TimeAt `json:"-" swaggerignore:"true"`
}


func (this *UpdateForm) BeforeUpdate(tx *gorm.DB) (err error) {
	this.UpdatedAt = TimeAt(time.Now())
	return
}