extends PlayerState


@onready var fall_state: State = $"../FallState"


func _ready() -> void:
	if not player.animation_finished.is_connected(_on_jump_start_finished):
		player.animation_finished.connect(_on_jump_start_finished)


func enter(_data: Variant = null) -> void:
	player.play_animation(&"jump_start")
	player.jump()


func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		player.move(direction, delta)

	if player.velocity.y >= 0:
		state_machine.change_state(fall_state)


func _on_jump_start_finished(animation_name: StringName) -> void:
	if animation_name != &"jump_start":
		return
	
	player.play_animation(&"jump_loop")
	pass
