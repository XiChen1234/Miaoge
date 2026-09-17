extends Node


const MAIN_MENU: PackedScene = preload("res://Scenes/Game/main_menu.tscn")
const LEVELS: Array[PackedScene] = [
	preload("res://Scenes/Level/level_01.tscn"),
	preload("res://Scenes/Level/level_02.tscn"),
	preload("res://Scenes/Level/level_03.tscn"),
	preload("res://Scenes/Level/level_04.tscn"),
	preload("res://Scenes/Level/level_05.tscn"),
]


var current_level: int = 0


func start_game() -> void:
	get_tree().change_scene_to_packed(LEVELS[current_level])


## 下一关卡
func next_level() -> void:
	current_level += 1
	if current_level < LEVELS.size():
		get_tree().change_scene_to_packed(LEVELS[current_level])
	else:
		print("game over")
