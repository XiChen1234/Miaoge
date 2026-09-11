extends Node
class_name State

var state_machine: StateMachine


func enter(_data: Variant = null) -> void:
	pass


func update(_delta: float) -> void:
	pass


func physics_update(_delta: float) -> void:
	pass


func exit() -> void:
	pass


## 通用事件监听入口
func handle_event(_event: StringName, _data: Variant = null) -> void:
	pass
