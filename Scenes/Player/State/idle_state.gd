extends PlayerState

@onready var walk_state: State = $"../WalkState"
@onready var jump_state: State = $"../JumpState"
@onready var fall_state: State = $"../FallState"

func enter(_data: Variant = null) -> void:
	player.play_animation(&"idle")


func physics_update(delta: float) -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction != 0:
		state_machine.change_state(walk_state)
		return
	
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return
	
	player.stop(delta)
	
	if not player.is_on_floor():
		state_machine.change_state(fall_state)
