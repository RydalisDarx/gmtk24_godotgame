class_name UpgradeHitbox
extends Node2D

@export_enum("dash", "double_jump") var upgrade_name := ""
@onready var sprite := $Sprite
var active := true

@export var upgrade_sheet := {
	"dash" = 1,
	"double_jump" = 2
}

signal upgrade_collected(upgrade_name)

func _ready():
	sprite.frame = upgrade_sheet[upgrade_name]

func _on_area_2d_body_entered(_body):
	if active:
		active = false
		upgrade_collected.emit(upgrade_name)
		sprite.visible = active
