extends Area2D
class_name Checkpoint

signal player_entered_checkpoint(checkpoint: Checkpoint)

@export var index: int = 0 # 0表示出生点
@export var is_active: bool = false


@onready var spawn_point: Marker2D = $SpawnPoint


func _on_player_entered(body: Node2D) -> void:
	if is_active:
		return
	
	if body is Player:
		player_entered_checkpoint.emit(self)
		is_active = true
