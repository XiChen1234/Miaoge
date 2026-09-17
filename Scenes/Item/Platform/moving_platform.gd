@tool
extends AnimatableBody2D
class_name MovingPlatform


@export var duration: float = 2
@export var end_offset: Vector2 = Vector2(200, 0):
	set(value):
		end_offset = value
		queue_redraw()


@onready var end_point: Marker2D = $EndPoint


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	handle_movement()


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	# 抵消父节点 scale 对线宽/半径的影响
	var s: float = maxf(absf(scale.x), 0.001)

	# 终点在“本节点局部坐标”下的位置
	var local_end: Vector2 = to_local(global_position + end_offset)

	# --- 1. 路径虚线 ---
	var line_color: Color = Color(1.0, 0.55, 0.1, 0.85)
	var steps: int = 36
	for i in range(steps):
		if i % 2 == 0:
			var t1: float = float(i) / float(steps)
			var t2: float = float(i + 1) / float(steps)
			draw_line(
				Vector2.ZERO.lerp(local_end, t1),
				Vector2.ZERO.lerp(local_end, t2),
				line_color,
				2.0 / s
			)

	# --- 2. 终点虚影（按 Sprite 实际尺寸） ---
	var size: Vector2 = Vector2(545, 135)  # 默认兜底尺寸
	var sprite: Sprite2D = get_node_or_null("Sprite2D") as Sprite2D
	if sprite:
		if sprite.region_enabled:
			size = sprite.region_rect.size
		elif sprite.texture:
			size = sprite.texture.get_size()

	var rect: Rect2 = Rect2(local_end - size * 0.5, size)
	draw_rect(rect, Color(1.0, 0.55, 0.1, 0.22), true)          # 半透明填充
	draw_rect(rect, Color(1.0, 0.55, 0.1, 0.9), false, 2.0 / s) # 描边


func handle_movement() -> void:
	# 执行移动
	var start: Vector2 = global_position
	var end: Vector2 = start + end_offset
	var tween: Tween = create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops()
	tween.tween_property(self, "global_position", end, duration)
	tween.tween_property(self, "global_position", start, duration)
	
