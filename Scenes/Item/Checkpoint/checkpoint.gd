extends Area2D
class_name Checkpoint

signal player_entered_checkpoint(checkpoint: Checkpoint)

@export var index: int = 0


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_checkpoint.emit(self)
