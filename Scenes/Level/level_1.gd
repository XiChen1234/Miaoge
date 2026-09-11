extends Node2D
class_name Level


@onready var player: Player = $Player


func _ready() -> void:
	player.dead.connect(_on_player_dead)


## 玩家死亡信号接收
func _on_player_dead() -> void:
	print("Level received player died")
