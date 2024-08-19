extends Sprite2D

@export var upgrade_name: String

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
		func(player_upgrade_name: String):
			if player_upgrade_name == upgrade_name:
				visible = true
				flash()
	)

func _process(_delta):
	if not visible:
		return

	if flip_h != player_sprite.flip_h:
		flip_h = player_sprite.flip_h

	material.set_shader_parameter("brightness", brightness)

func flash():
	var tw = get_tree().create_tween()

	brightness = 10.0
	tw.tween_property(self, "brightness", 1.0, 0.5)