extends Node

signal got_upgrade(upgrade_name: String, is_permanent: bool)
signal lost_upgrade(upgrade_name: String)
signal upgrade_loaded(upgrade_name: String)

func _ready() -> void:
	# This can be removed for release, just scales up the window when not in fullscreen. Needed to see for small pixel art resolutions
	var window_size = Vector2i(1920, 1080)
	DisplayServer.window_set_size(window_size)
	#DisplayServer.window_set_position(DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2) - ( window_size / 2) )

	# Engine.time_scale = 0.15
