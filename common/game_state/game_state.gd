extends Node

var start_run
var spawn_next_section
var next_section_spawn_location
var player_health
var game_over
var dying
var obstacle_spawn_chance
var player_speed
var lose_balance
var player_hurt

func _ready() -> void:
	init()

func init():
	start_run = true
	spawn_next_section = false
	next_section_spawn_location = null
	player_health = null
	game_over = false
	dying = false
	obstacle_spawn_chance = 0.25
	player_speed = 5.0
	lose_balance = false
	player_hurt = false
