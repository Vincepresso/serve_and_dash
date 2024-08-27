class_name Camera extends Node3D

@export var follow_target: Node3D
@export var shake_magnitude = 0.05
@export var shaking = false

var is_sliding = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cam: Camera3D = $SpringArm3D/Camera3D

func _process(delta: float) -> void:
	if not GameState.dying:
		global_position = follow_target.global_position
	elif !is_sliding:
		is_sliding = true
		animation_player.play("slide_up")
	shake()

func shake():
	if shaking:
		var shake_amount = Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)) * shake_magnitude
		cam.global_position += shake_amount

func trigger_shake(shake_duration):
	if not shaking:
		shaking = true
		await get_tree().create_timer(shake_duration).timeout
		shaking = false
