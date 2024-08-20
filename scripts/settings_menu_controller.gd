extends Control

@onready var master_slider := $"Audio Options/Master/HSlider"
@onready var bgm_slider := $"Audio Options/BGM/HSlider2"
@onready var sfx_slider := $"Audio Options/SFX/HSlider3"


func _ready() -> void:
	print(AudioServer.get_bus_volume_db(0))
	print(db_to_linear(AudioServer.get_bus_volume_db(0)))
	print(master_slider.value)
	$confirm.grab_focus()
	if SceneManager.currentScene != get_tree().current_scene.scene_file_path:
		SceneManager.currentScene = get_tree().current_scene.scene_file_path
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0)) * 100
	bgm_slider.value = db_to_linear(AudioServer.get_bus_volume_db(1)) * 100
	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(2)) * 100

	get_tree().paused = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100))


func _on_h_slider_2_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value / 100))


func _on_h_slider_3_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2,  linear_to_db(value / 100))


func _on_confirm_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/screens/TitleScreen.tscn")
	AudioServer.set_bus_volume_db(0, linear_to_db(master_slider.value / 100))
	AudioServer.set_bus_volume_db(1, linear_to_db(bgm_slider.value / 100))
	AudioServer.set_bus_volume_db(2,  linear_to_db(sfx_slider.value / 100))