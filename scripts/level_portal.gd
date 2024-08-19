extends Area2D

var levelsuffix = ".tscn"

@export var scenename := ""
@onready var current_scene = get_tree().get_current_scene()

signal goto_scene(scenename)

func _ready():
	print(current_scene)
	if scenename.ends_with(".tscn"):
		levelsuffix = ""
	
	goto_scene.connect(current_scene._loadScene)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		print("Player collided with level swapper")
		print("Changing scene to " + scenename)
		goto_scene.emit(scenename + levelsuffix)
