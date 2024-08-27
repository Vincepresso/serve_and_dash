extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	var random_pose_indices = ["1","2","3","4"]
	animation_player.play("humanoid_poses/pose_" + random_pose_indices.pick_random())
