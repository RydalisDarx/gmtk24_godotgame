extends Sprite2D

func _on_area_2d_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		var tw = get_tree().create_tween()
		tw.tween_property(self, "modulate:a", 0.71, 0.1)


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if _body.is_in_group("Player"):
		var tw = get_tree().create_tween()
		tw.tween_property(self, "modulate:a", 1.0, 0.1)
