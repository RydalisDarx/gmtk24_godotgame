extends Control

@onready var start_button = $"%StartButton"
@onready var quit_button = $"%QuitButton"
@onready var settings_button = $"%Settings"
@onready var credits_button = $"%Credits"
@onready var animation_player = $"%animation_player"


func _ready() -> void:

	animation_player.play("fade_in")
	await animation_player.animation_finished
	start_button.grab_focus()
	if SceneManager.currentScene != get_tree().current_scene.scene_file_path:
		SceneManager.currentScene = get_tree().current_scene.scene_file_path
	
	start_button.button_down.connect(
		func():
			animation_player.play('start_game')
			await animation_player.animation_finished
			get_tree().change_scene_to_file("res://scenes/levels/outside_level_1.tscn")
	)

	quit_button.button_down.connect(
		func():
				get_tree().quit()
	)
	
	settings_button.button_down.connect(
		func():
				get_tree().change_scene_to_file("res://scenes/screens/SettingsMenu.tscn")
	)
	
	credits_button.button_down.connect(
		func():
				get_tree().change_scene_to_file("res://scenes/screens/credits.tscn")
	)
