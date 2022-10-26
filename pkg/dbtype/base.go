package dbtype

import (
	"time"

	"gorm.io/gorm"
)

type Base struct {
	ID        int64  `json:"id" gorm:"primaryKey"`
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
