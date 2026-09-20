extends Control
class_name MainMenu


@onready var popue: Popue = $Popue


func _on_start() -> void:
	GameManager.start_game()


func _on_saves() -> void:
	popue.open(Popue.Mode.SAVES)


func _on_setting() -> void:
	pass # Replace with function body.


func _on_exit() -> void:
	pass # Replace with function body.
