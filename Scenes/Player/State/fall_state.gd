extends PlayerState


@onready var land_state: State = $"../LandState"


func enter(_data: Variant = null) -> void:
	player.play_animation(&"jump_loop")


func physics_update(delta: float) -> void:
	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		player.move(direction, delta)
	
	if player.is_on_floor():
		state_machine.change_state(land_state)
