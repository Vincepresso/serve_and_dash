extends Node

@export var obstalce_spawn_rate = 0.03
@export var player_speed_rate = 0.5
@onready var difficulty_increase_timer: Timer = $DifficultyIncreaseTimer

var started = false

func _process(delta: float) -> void:
	if GameState.start_run and not started:
		started = true
		difficulty_increase_timer.start()

	if not GameState.start_run and started:
		started = false
		difficulty_increase_timer.paused = true

func _on_difficulty_increase_timer_timeout() -> void:
	if not GameState.dying and not GameState.game_over:
		GameState.obstacle_spawn_chance += obstalce_spawn_rate
		GameState.obstacle_spawn_chance = clampf(GameState.obstacle_spawn_chance, 0.0, 1.0)
		GameState.player_speed += player_speed_rate
		GameState.player_speed = clampf(GameState.player_speed, 5.0, 15.0)
