extends Area2D

const LEVELPATH = "res://scenes/levels/"
var levelsuffix = ".tscn"

@export var scenename := ""

func _ready():
	if scenename.ends_with(".tscn"):
		levelsuffix = ""

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player collided with level swapper")
		print("Changing scene to " + scenename)
		get_tree().change_scene_to_file.call_deferred(LEVELPATH + scenename + levelsuffix)
