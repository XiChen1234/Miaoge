extends Area2D
class_name ExitArea


signal level_end_signal()


func _on_player_entered(body: Node2D) -> void:
	if body is Player:
		level_end_signal.emit.call_deferred()
