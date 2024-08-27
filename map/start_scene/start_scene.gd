extends Node3D

@onready var animation_player_tut: AnimationPlayer = $AnimationPlayerTut
@onready var animation_player_main_menu: AnimationPlayer = $AnimationPlayerMainMenu

func _on_play_button_pressed() -> void:
	animation_player_main_menu.play("dissolve")
	await animation_player_main_menu.animation_finished
	animation_player_tut.play_backwards("dissolve")
	await get_tree().create_timer(5).timeout
	load_highway_scene()

func load_highway_scene():
	SceneTransition.transition_to(GameState.highway_scene_path)
