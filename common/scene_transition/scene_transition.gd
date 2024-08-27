extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func transition_to(target: String):
	animation_player.play_backwards("dissolve")
	await animation_player.animation_finished
	GameState.init()
	get_tree().change_scene_to_file(target)
	animation_player.play("dissolve")
