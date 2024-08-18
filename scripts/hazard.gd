class_name Hazard
extends Node2D

signal hazard_collision

func _ready():
	var player_nodes = get_tree().get_nodes_in_group("Player")
	
	for player in player_nodes:
		hazard_collision.connect(player._on_hazard_collision)

func _on_body_entered(body : Node2D):
	if body.is_in_group("Player"):
		hazard_collision.emit()
