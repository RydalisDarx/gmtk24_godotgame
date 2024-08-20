extends Control

@onready var start_button = $"%StartButton"
@onready var quit_button = $"%QuitButton"
@onready var animation_player = $"%animation_player"


func _ready() -> void:

	animation_player.play("fade_in")
	await animation_player.animation_finished
	start_button.grab_focus()

	start_button.button_down.connect(
		func():
			animation_player.play('start_game')
			await animation_player.animation_finished
			get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
	)

	quit_button.button_down.connect(
		func():
				get_tree().quit()
	)
