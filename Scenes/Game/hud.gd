extends Control
class_name HUD


@onready var hearts: Array[TextureRect] = [
	$HealthHBox/Heart,
	$HealthHBox/Heart2,
	$HealthHBox/Heart3,
]

@export var heart_texture: Texture2D
@export var heart_empty_texture: Texture2D


func update_health(health: int) -> void:
	for i in hearts.size():
		if i < health:
			hearts[i].texture = heart_texture
		else:
			hearts[i].texture = heart_empty_texture
