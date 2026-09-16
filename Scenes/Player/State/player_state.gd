extends State
class_name PlayerState


@onready var player: Player = $"../.."
@onready var hurt_state: State = $"../HurtState"
@onready var death_state: State = $"../DeathState"


func handle_event(_event: StringName, _data: Variant = null) -> void:
	if _event == &"hurt":
		state_machine.change_state(hurt_state, _data)
	elif _event == &"death":
		state_machine.change_state(death_state)
