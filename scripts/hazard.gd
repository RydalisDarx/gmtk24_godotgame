class_name Hazard
extends Node2D

signal hazard_collision

func _on_body_entered(body):
	hazard_collision.emit()
