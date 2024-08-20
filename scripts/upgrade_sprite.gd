extends Sprite2D

@export var triggered_by_upgrades: Array[String]

var player_sprite: Sprite2D
var brightness := 1.0

func _ready() -> void:
	player_sprite = get_parent()
	frame = player_sprite.frame
	flip_h = player_sprite.flip_h
	visible = false

	material = ShaderMaterial.new()
	material.shader = preload("res://scripts/shaders/brightness.gdshader")



	player_sprite.frame_changed.connect(
		func():
			frame = player_sprite.frame
	)

	GameController.got_upgrade.connect(
		func(upgrade_name: String, is_permanent: bool):
			if triggered_by_upgrades.has(upgrade_name):

				if not is_permanent:
					modulate = Color("#00ff00")

				visible = true
				flash()
	)

	GameController.lost_upgrade.connect(
		func(upgrade_name: String):
			if triggered_by_upgrades.has(upgrade_name):
				flash()
				var tw = get_tree().create_tween()
				tw.tween_property(self, "modulate:a", 0.0, 1.0)
				await tw.finished
				modulate = Color(1, 1, 1, 1)
				visible = false
	)

	GameController.upgrade_loaded.connect(
		func(upgrade_name: String):
			if triggered_by_upgrades.has(upgrade_name):
				visible = true
	)

func _process(_delta):
	if not visible:
		return

	if flip_h != player_sprite.flip_h:
		flip_h = player_sprite.flip_h

	material.set_shader_parameter("brightness", brightness)

func flash(length := 0.25):
	brightness = 10.0

	var tw = get_tree().create_tween()
	tw.tween_property(self, "brightness", 1.0, length)
	await tw.finished
