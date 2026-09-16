extends PlayerState


@onready var idle_state: State = $"../IdleState"


var _hurt_timer: float = 0.0


func enter(_data: Variant = null) -> void:
	var damage: int = _data["damage"]
	
	player.take_damage(damage)
	if player.health <= 0:
		# 直接执行死亡流程
		player.die()
		return
	
	player.set_invincible(true)
	player.knockback()
	player.play_animation("hurt")

	
	_hurt_timer = player.get_hurt_duration()


func physics_update(_delta: float) -> void:
	player.decelerate_knockback(_delta)
	_hurt_timer -= _delta
	
	if _hurt_timer <= 0:
		player.set_invincible(false)
		state_machine.change_state(idle_state)
