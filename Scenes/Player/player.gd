extends CharacterBody2D
class_name Player


signal animation_finished(animation_name: StringName)
signal death_signal()


# ===== 移动 =====
@export_category("Movement")
@export var _max_speed: float = 350.0
@export var _accel: float = 2400.0
@export var _decel: float = 3500.0

# ===== 跳跃 =====
@export_category("Jump")
@export var _jump_velocity: float = -800.0
@export var _gravity: float = 1800.0
@export var _max_fall_speed: float = 1000.0

# ===== 受击 =====
@export_category("Health")
@export var _max_health: int = 3
@export var _hurt_duration: float = 0.4
@export var _knockback_speed: float = 500.0
@export var _knockback_decel: float = 1800.0

var health: int
var _is_invincible: bool = false


## ===== 跳跃辅助 =====
#@export_category("Jump Assist")
## 土狼时间：
## 离开平台后的一小段时间内仍然允许跳跃
#@export var coyote_time: float = 0.10
## 跳跃缓冲：
## 提前按下跳跃键，落地后自动起跳
#@export var jump_buffer_time: float = 0.12
## 松开跳跃键后，降低上升速度
## 数值越小，短跳越明显
#@export var jump_cut_multiplier: float = 0.45

@onready var visual: Node2D = $Visual
@onready var animated_sprite_2d: AnimatedSprite2D = $Visual/AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	state_machine.start()
	health = _max_health


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	move_and_slide()


## 应用重力
func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y = move_toward(velocity.y, _max_fall_speed, _gravity * delta)


## 玩家移动接口
func move(direction: int, delta: float) -> void:
	velocity.x = move_toward(velocity.x, direction * _max_speed, _accel * delta)
	if direction != 0:
		visual.scale.x = direction


## 玩家停止接口
func stop(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, _decel * delta)


## 获取玩家左右移动状态的接口
func is_stopped() -> bool:
	return is_zero_approx(velocity.x)


## 玩家跳跃接口
func jump() -> void:
	velocity.y = _jump_velocity


## 玩家播放动画接口
func play_animation(animation_name: StringName) -> void:
	if animated_sprite_2d.animation != animation_name:
		animated_sprite_2d.play(animation_name)
	elif not animated_sprite_2d.is_playing():
		animated_sprite_2d.play(animation_name)


func _on_animated_finished() -> void:
	animation_finished.emit(animated_sprite_2d.animation)


## 玩家造成伤害接口
func take_damage(damage: int) -> void:
	health = health - damage


## 玩家死亡接口
func die() -> void:
	state_machine.handle_event(&"death")


## 玩家重生接口
func respawn(spawn_position: Vector2) -> void:
	global_position = spawn_position
	velocity = Vector2.ZERO
	health = _max_health
	set_invincible(false)
	visual.modulate.a = 1.0
	visual.position = Vector2.ZERO
	state_machine.change_state(state_machine.init_state)


## 玩家无敌状态设置接口
func set_invincible(value: bool) -> void:
	_is_invincible = value


## 获取受击间隔时间接口
func get_hurt_duration() -> float:
	return _hurt_duration


## 玩家被击退接口
func knockback() -> void:
	var direction: float = -signf(velocity.x)
	if direction == 0:
		direction = -signf(visual.scale.x)

	velocity.x = direction * _knockback_speed


func decelerate_knockback(delta: float) -> void:
	velocity.x = move_toward(velocity.x, 0, _knockback_decel * delta)


func _on_hurt_box_entered(body: Node2D) -> void:
	if _is_invincible:
		return
	
	print(body)
	if body is SpikeLayer:
		state_machine.handle_event(&"hurt", {"damage": 1, "source": body})
