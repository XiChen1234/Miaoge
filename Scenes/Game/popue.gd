extends Control
class_name Popue

# 决定弹窗内容
enum Mode {
	SAVES, SETTINGS, PAUSE
}

const PANEL_WIDTH: float = 652.0
const ANIMATE_DURATION: float = 0.38

var is_open: bool = false
var current_mode: Mode
var _tween: Tween

@onready var mask: ColorRect = $Mask
@onready var background: TextureRect = $Background


func _ready() -> void:
	background.offset_left = 0
	background.offset_right = PANEL_WIDTH
	mask.modulate.a = 0
	mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = false


func _unhandled_input(event: InputEvent) -> void:
	if not is_open:
		return
	
	if event.is_action_pressed("esc"):
		close()
		get_viewport().set_input_as_handled()


func open(mode: Mode) -> void:
	if is_open:
		return
	
	is_open = true
	visible = true
	current_mode = mode
	_open_animate()


func close() -> void:
	if not is_open:
		return
	
	is_open = false
	if current_mode == Mode.PAUSE:
		get_tree().paused = false
	
	_close_animate()


func _open_animate() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	
	mask.mouse_filter = Control.MOUSE_FILTER_STOP
	_tween = create_tween().set_parallel(true)
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(background, "offset_left", -PANEL_WIDTH, ANIMATE_DURATION)
	_tween.tween_property(background, "offset_right", 0, ANIMATE_DURATION)
	_tween.tween_property(mask, "modulate:a", 1, ANIMATE_DURATION)


func _close_animate() -> void:
	if _tween and _tween.is_valid():
		_tween.kill()
	
	_tween = create_tween().set_parallel(true)
	_tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	_tween.tween_property(background, "offset_left", 0.0, ANIMATE_DURATION)
	_tween.tween_property(background, "offset_right", PANEL_WIDTH, ANIMATE_DURATION)
	_tween.tween_property(mask, "modulate:a", 0.0, 0.2)
	# 动画全部播完后，把节点藏起来，不再吃输入
	_tween.chain().tween_callback(func() -> void:
		visible = false
		mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	)


func _on_mask_clicked(event: InputEvent) -> void:
		if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
			close()
			get_viewport().set_input_as_handled() # 阻止事件穿透


func _on_back() -> void:
	close()
	get_viewport().set_input_as_handled()
