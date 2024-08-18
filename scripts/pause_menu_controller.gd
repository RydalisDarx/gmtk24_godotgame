extends Control

func resume() -> void:
	$PanelContainer/VBoxContainer.visible = false
	get_tree().paused = false;
	$AnimationPlayer.play_backwards("ScreenBlur")
	
func pause() -> void:
	$PanelContainer/VBoxContainer.visible = true
	get_tree().paused = true;
	$AnimationPlayer.play("ScreenBlur")

func escaping() -> void: 
	if Input.is_action_just_pressed("pause") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused:
		resume()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$PanelContainer/VBoxContainer.visible = false
	$AnimationPlayer.play("RESET")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	escaping()


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene();
	pass # Replace with function body.


func _on_resume_button_pressed() -> void:
	resume()
	pass # Replace with function body.


func _on_menu_button_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://scenes/screens/TitleScreen.tscn")
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	resume()
	get_tree().quit()
	pass # Replace with function body.


func _on_resume_button_draw() -> void:
	pass # Replace with function body.
