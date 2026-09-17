extends AnimatableBody2D
class_name DisappearPlatform


@export var safe_delay: float = 0.8     # 平台存续延迟时间
@export var fade_delay: float = 0.5     # 消失动画开始播放时间
@export var fade_duration: float = 0.5  # 消失/出现动画持续时间
@export var respawn_delay: float = 2.0  # 平台重生时间

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var disappear_area: Area2D = $DisappearArea

var _busy: bool = false


func _on_player_entered(body: Node2D) -> void:
	if _busy:
		return
	if not body is Player:
		return
	_busy = true
	start_disappear()


func start_disappear() -> void:
	var safe_timer := get_tree().create_timer(safe_delay)
	var fade_timer := get_tree().create_timer(fade_delay)

	# fade_delay 到：开始淡出
	await fade_timer.timeout
	var fade_out := create_tween()
	fade_out.tween_property(sprite_2d, "modulate:a", 0.0, fade_duration)

	# safe_delay 到：关碰撞
	await safe_timer.timeout
	collision_shape_2d.set_deferred("disabled", true)
	disappear_area.set_deferred("monitoring", false)

	await fade_out.finished

	# 重生倒计时
	await get_tree().create_timer(respawn_delay).timeout
	collision_shape_2d.set_deferred("disabled", false)
	disappear_area.set_deferred("monitoring", true)
	var fade_in := create_tween()
	fade_in.tween_property(sprite_2d, "modulate:a", 1.0, fade_duration)
	await fade_in.finished

	# 重生后若玩家仍在触发区内，立即重新触发
	await get_tree().physics_frame
	for body in disappear_area.get_overlapping_bodies():
		if body is Player:
			start_disappear()
			return

	_busy = false
