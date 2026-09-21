extends Node
class_name StateMachine

var states: Dictionary = {}
var current_state: State

@export var init_state: State

var _debug_label: Label


func _ready() -> void:
	_debug_label = get_node_or_null("CanvasLayer/Label") as Label
	
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.state_machine = self
	
	if init_state == null:
		push_error("StateMachine: 未设置初始状态")
		return


func _process(delta: float) -> void:
	current_state.update(delta)


func _physics_process(delta: float) -> void:
	current_state.physics_update(delta)


func start() -> void:
	if init_state == null:
		return
	
	current_state = init_state
	current_state.enter()
	_update_debug_label()


func change_state(new_state: State, data: Variant = null) -> void:
	if current_state == new_state:
		return
	
	if current_state != null:
		current_state.exit()
	
	current_state = new_state
	_update_debug_label()
	
	if new_state != null:
		new_state.enter(data)


func handle_event(event: StringName, data: Variant = null) -> void:
	if current_state == null:
		return
	
	current_state.handle_event(event, data)


func _update_debug_label() -> void:
	if _debug_label == null or current_state == null:
		return
	_debug_label.text = "当前状态：" + current_state.name
