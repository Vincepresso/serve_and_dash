extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var footstep_sfx: AudioStreamPlayer3D = $FootstepSfx

func _ready() -> void:
	randomize()
	var random_index = ["1","2","3"].pick_random()
	animation_player.play("humanoid/dance_" + random_index)
