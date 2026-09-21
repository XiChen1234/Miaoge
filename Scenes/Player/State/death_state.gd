extends PlayerState


func enter(_data: Variant = null) -> void:
	player.velocity = Vector2.ZERO
	player.set_invincible(true)
	var tween := player.create_tween()
	tween.tween_property(
		player.visual,
		"modulate:a",
		0.0,
		0.2
	)
	
	tween.finished.connect(_on_body_faded)


func _on_body_faded() -> void:
	player.visual.modulate.a = 1
	player.play_animation("dead")

	var tween := player.create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		player.visual,
		"position:y",
		player.visual.position.y - 80.0,
		1.2
	)
	tween.tween_property(
		player.visual,
		"modulate:a",
		0.0,
		1.2
	)
	tween.finished.connect(_on_death_animation_finished)


func _on_death_animation_finished() -> void:
	player.died.emit()
