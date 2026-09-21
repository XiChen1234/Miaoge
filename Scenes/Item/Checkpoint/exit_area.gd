extends Area2D
class_name ExitArea


signal level_ended()


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		level_ended.emit.call_deferred()
