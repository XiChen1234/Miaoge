extends PlayerState


@onready var idle_state: State = $"../IdleState"
@onready var jump_state: State = $"../JumpState"
@onready var fall_state: State = $"../FallState"


func enter(_data: Variant = null) -> void:
	player.play_animation(&"walk")


func physics_update(delta: float) -> void:
	if not player.is_on_floor():
		state_machine.change_state(fall_state)
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return
	
	var direction = Input.get_axis("move_left", "move_right")
	player.move(direction, delta)
	
	if direction == 0 and player.is_stopped():
		state_machine.change_state(idle_state)
		return
