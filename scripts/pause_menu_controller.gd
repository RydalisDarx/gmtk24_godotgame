extends Control

@onready var focus_button = $PanelContainer/VBoxContainer/ResumeButton;
const SETTINGS_MENU = preload("res://scenes/screens/SettingsMenu.tscn")

func resume() -> void:
	$PanelContainer/VBoxContainer.visible = false
	get_tree().paused = false;
	$AnimationPlayer.play_backwards("ScreenBlur")
	for b : Button in $PanelContainer/VBoxContainer.get_children():
		b.release_focus()
	
func pause() -> void:
	$PanelContainer/VBoxContainer.visible = true
	get_tree().paused = true;
	$AnimationPlayer.play("ScreenBlur")
	focus_button.grab_focus()

func escaping() -> void: 
	if Input.is_action_just_pressed("pause"): 
		if !get_tree().paused:
			pause()
		else:
			resume()
	elif Input.is_action_just_pressed("ui_cancel") and get_tree().paused:
		resume()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/VBoxContainer.visible = false
	$AnimationPlayer.play("RESET")

func _process(_delta: float) -> void:
	escaping()


func _on_settings_button_pressed() -> void:
	resume()
	SceneManager.stopMusic()
	get_tree().change_scene_to_packed(SETTINGS_MENU)


func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene();
	pass # Replace with function body.


func _on_resume_button_pressed() -> void:
	resume()
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	SceneManager.stopMusic()
	resume()
	get_tree().change_scene_to_file("res://scenes/screens/TitleScreen.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	resume()
	get_tree().quit()
	pass # Replace with function body.
