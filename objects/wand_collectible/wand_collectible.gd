extends Area2D

@onready var sprite = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"player"):
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)

		tween.tween_property(sprite, "global_position", body.global_position + Vector2(8.5, 4.5), 0.1)
		tween.parallel().tween_property(sprite, "rotation_degrees", 360.0, 0.1)
		await tween.finished

		PlayerStats.player_has_wand = true
		body.wand.visible = true
		queue_free()
