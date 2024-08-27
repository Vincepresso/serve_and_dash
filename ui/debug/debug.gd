extends CanvasLayer

var player

@onready var start_run_value: Label = $DebugControl/VBoxContainer/GameStateGrid/StartRunValue
@onready var fps_value: Label = $DebugControl/VBoxContainer/SystemGrid/FPSValue
@onready var health_value: Label = $DebugControl/VBoxContainer/GameStateGrid/HealthValue
@onready var player_speed_value: Label = $DebugControl/VBoxContainer/GameStateGrid/PlayerSpeedValue
@onready var obstacle_spawn_chance_value: Label = $DebugControl/VBoxContainer/GameStateGrid/ObstacleSpawnChanceValue
@onready var release_tray_button: Button = $DebugControl/VBoxContainer/GameStateGrid/ReleaseTrayButton

func _ready() -> void:
	var player_groups = get_tree().get_nodes_in_group("player")
	if player_groups:
		player = player_groups[0] as Player

func _process(delta: float) -> void:
	start_run_value.text = str(GameState.start_run)
	fps_value.text = str(Engine.get_frames_per_second())
	health_value.text = str(GameState.player_health)
	player_speed_value.text = str(GameState.player_speed)
	obstacle_spawn_chance_value.text = str(GameState.obstacle_spawn_chance)

func _on_start_run_toggle_pressed() -> void:
	GameState.start_run = !GameState.start_run

func _on_health_button_pressed() -> void:
	if player:
		player.hurt()

func _on_release_tray_button_pressed() -> void:
	if player:
		player.release_tray(Vector3.FORWARD * 3)
