extends Node
class_name PlayerProperties

var permanent_upgrades := {}

func _init(upgrades = 
	{"double_jump":false,
	"dash":false,
	"wall_cling":true}):
	for upgrade in upgrades.keys():
		permanent_upgrades[upgrade] = upgrades[upgrade]

func set_upgrades(upgrades):
	for upgrade in upgrades.keys():
		permanent_upgrades[upgrade] = upgrades[upgrade]
		
func set_upgrade(upgrade: String, val: bool):
	permanent_upgrades[upgrade] = val

# Print player properties
func Print() -> void:
	print(permanent_upgrades)
