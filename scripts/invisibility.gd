extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		var tw = get_tree().create_tween()
		tw.tween_property(self, "modulate:a", 0.71, 0.1)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		var tw = get_tree().create_tween()
		tw.tween_property(self, "modulate:a", 1.0, 0.1)
	pass # Replace with function body.
