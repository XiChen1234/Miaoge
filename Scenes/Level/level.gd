extends Node2D
class_name Level


@onready var player: Player = $Entities/Player # 这个Player是一定有的
@onready var checkpoints: Node2D = $Checkpoints
@onready var exit_area: ExitArea = $Checkpoints/ExitArea
@onready var popue: Popue = $UI/Popue
@onready var hud: HUD = $UI/HUD	

@export var index: int = 0

var current_checkpoint: Checkpoint


func _ready() -> void:
	for child in checkpoints.get_children():
		if child is Checkpoint:
			child.player_entered_checkpoint.connect(_on_checkpoint_entered)
			if child.index == 0:
				current_checkpoint = child
	
	exit_area.level_end_signal.connect(_on_level_end)
	
	player.death_signal.connect(_on_player_death)
	player.global_position = current_checkpoint.spawn_point.global_position
	
	player.health_changed.connect(_on_player_health_changed)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		get_tree().paused = true
		popue.open(Popue.Mode.PAUSE)


func _on_checkpoint_entered(checkpoint: Checkpoint) -> void:
	if current_checkpoint == null:
		return
	
	if checkpoint.index > current_checkpoint.index:
		current_checkpoint = checkpoint


func _on_level_end() -> void:
	GameManager.next_level()


func _on_player_death() -> void:
	print("death")
	print("玩家死亡，当前检查点：", current_checkpoint.index)
	player.respawn(current_checkpoint.spawn_point.global_position)


func _on_player_health_changed(health: int) -> void:
	hud.update_health(health)
