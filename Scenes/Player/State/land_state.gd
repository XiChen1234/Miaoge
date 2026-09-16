extends PlayerState


@onready var idle_state: State = $"../IdleState"
@onready var walk_state: PlayerWalkState = $"../WalkState"
@onready var jump_state: State = $"../JumpState"


func enter(_data: Variant = null) -> void:
	player.velocity.y = 0.0
	player.play_animation(&"jump_end")
	if not player.animation_finished.is_connected(_on_jump_end_finished):
		player.animation_finished.connect(_on_jump_end_finished)


func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return
	
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		player.move(direction, delta)
	else:
		player.stop(delta)


func _on_jump_end_finished(animation_name: StringName) -> void:
	if animation_name != &"jump_end":
		return
	
	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		state_machine.change_state(walk_state)
	else:
		state_machine.change_state(idle_state)
