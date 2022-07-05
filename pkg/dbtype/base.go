package dbtype

import (
	"time"

	"gorm.io/gorm"
)

type Base struct {
	ID        int64 `gorm:"primaryKey"`
	CreatedAt TimeAt
	UpdatedAt TimeAt
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
