class_name UpgradeHitbox
extends Node2D

@export_enum("dash", "double_jump") var upgrade_name := ""
@export var permanent := false
@export var duration := 10.0
@onready var sprite := $Sprite
var active := true

@export var upgrade_sheet := {
	"dash" = 1,
	"double_jump" = 2
}

signal upgrade_collected(upgrade_name, permanent, duration)

func _ready():
	sprite.frame = upgrade_sheet[upgrade_name]

func _on_area_2d_body_entered(_body):
	if active and _body.is_in_group("Player"):
		active = false
		upgrade_collected.emit(upgrade_name, permanent, duration)
		sprite.visible = active
