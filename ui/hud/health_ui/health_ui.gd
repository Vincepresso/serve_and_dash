extends Control

@onready var health_texture_1: TextureRect = $HBoxContainer/HealthTexture1
@onready var health_texture_2: TextureRect = $HBoxContainer/HealthTexture2

func _ready() -> void:
	health_texture_1.visible = true
	health_texture_2.visible = true

func _process(delta: float) -> void:
	if GameState.player_health == 0 and health_texture_1.visible:
		health_texture_1.visible = false

	if GameState.player_health == 1 and health_texture_2.visible:
		health_texture_2.visible = false
