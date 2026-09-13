extends Node2D
class_name Level


@onready var player: Player = $Entities/Player
@onready var checkpoints: Node2D = $Checkpoints

var current_checkpoint: Checkpoint


func _ready() -> void:
	for child in checkpoints.get_children():
		if child is Checkpoint:
			child.player_entered_checkpoint.connect(_on_checkpoint_entered)
			if child.index == 0:
				current_checkpoint = child
		


func _on_checkpoint_entered(checkpoint: Checkpoint) -> void:
	if current_checkpoint == null:
		return
	
	if checkpoint.index > current_checkpoint.index:
		current_checkpoint = checkpoint
