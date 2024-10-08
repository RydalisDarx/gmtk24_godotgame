class_name UpgradeHitbox
extends Node2D

@export_enum("bonus_jump", "dash", "double_jump", "wall_cling") var upgrade_name := ""
@export var permanent := false
@export var duration := 1.0
@export var reappear_time := 0 #time for the time to reappear. If 0, doesn't
@onready var sprite := $Sprite
var active := true

const PERM_PICKUPS_SHEET = preload("res://assets/perm_pickups_sheet.png")
const TEMP_PICKUPS_SHEET = preload("res://assets/temp_pickups_sheet.png")

@export var upgrade_sheet := {
	"bonus_jump" = 2,
	"wall_cling" = 1,
	"double_jump" = 2,
	"dash" = 3,
}

signal upgrade_collected(upgrade_name, permanent, duration)

func _ready():
	if permanent:
		sprite.texture = PERM_PICKUPS_SHEET
	else:
		sprite.texture = TEMP_PICKUPS_SHEET
	sprite.frame = upgrade_sheet[upgrade_name]
	var player_nodes = get_tree().get_nodes_in_group("Player")
	
	for player in player_nodes:
		upgrade_collected.connect(player._on_upgrade_collected)

func _on_area_2d_body_entered(_body):
	print(upgrade_name + " collided with player")
	if active and _body.is_in_group("Player"):
		active = false
		upgrade_collected.emit(upgrade_name, permanent, duration)
		sprite.visible = active
		if reappear_time > 0 and permanent == false:
			await get_tree().create_timer(reappear_time).timeout
			active = true
			sprite.visible = active
