extends Control
class_name Popue

signal closed # 关闭弹窗的信号
signal exit_requested # 从level退出游戏的信号

# 决定弹窗内容
enum Mode {
	SAVES, SETTINGS, PAUSE
}

const PANEL_WIDTH: float = 652.0
const ANIMATE_DURATION: float = 0.38

const TITLE_DICTIONARY: Dictionary = {
	Mode.SAVES: {
		"text": "存档",
		"texture": preload("res://Resources/UI/Main/main_img_loadgame.png"),
	},
	Mode.SETTINGS: {
		"text": "设置",
		"texture": preload("res://Resources/UI/Main/main_img_setting.png"),
	},
	Mode.PAUSE: {
		"text": "菜单",
		"texture": preload("res://Resources/UI/Main/main_img_menue.png"),
	},
}

var is_open: bool = false
var current_mode: Mode
var _tween: Tween

@onready var mask: ColorRect = $Mask
@onready var background: TextureRect = $Background
@onready var title: TextureRect = $Background/Title
@onready var title_label: Label = $Background/Title/TitleLabel
@onready var saves_v_box: VBoxContainer = $Background/SavesVBox
@onready var pause_v_box: VBoxContainer = $Background/PauseVBox
@onready var settings_v_box: VBoxContainer = $Background/SettingsVBox
@onready var volume_slider: HSlider = $Background/SettingsVBox/VolumeSlider


func _ready() -> void:
	background.offset_left = 0
	background.offset_right = PANEL_WIDTH
	mask.modulate.a = 0
	mask.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	visible = false
	saves_v_box.visible = false
	pause_v_box.visible = false
	settings_v_box.visible = false
	
	volume_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))


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
	
	_update_content()
	_open_animate()


func switch_mode(mode: Mode) -> void:
	if not is_open:
		return
	
	current_mode = mode
	_update_content()


func close() -> void:
	if not is_open:
		return
	
	is_open = false
	closed.emit()
	
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


func _update_content() -> void:
	saves_v_box.visible = false
	pause_v_box.visible = false
	settings_v_box.visible = false

	match current_mode:
		Mode.SAVES:
			saves_v_box.visible = true
		Mode.PAUSE:
			pause_v_box.visible = true
		Mode.SETTINGS:
			settings_v_box.visible = true

	var title_data: Dictionary = TITLE_DICTIONARY[current_mode]
	title.texture = title_data["texture"]
	title_label.text = title_data["text"]


func _on_mask_clicked(event: InputEvent) -> void:
		if event is InputEventMouseButton \
			and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
			close()
			get_viewport().set_input_as_handled() # 阻止事件穿透


func _on_back() -> void:
	close()
	get_viewport().set_input_as_handled()


func _on_saves_button_pressed() -> void:
	switch_mode(Mode.SAVES)


func _on_settings_button_pressed() -> void:
	switch_mode(Mode.SETTINGS)


func _on_exit_button_pressed() -> void:
	close()
	exit_requested.emit()


func _on_volume_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
