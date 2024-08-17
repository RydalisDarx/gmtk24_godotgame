extends Node

func _ready() -> void:

	# This can be removed for release, just scales up the window for debug
	var window_size = Vector2i(1920, 1080)
	DisplayServer.window_set_size(window_size)
	DisplayServer.window_set_position(DisplayServer.screen_get_position() + (DisplayServer.screen_get_size() / 2) - ( window_size / 2) )