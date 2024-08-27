class_name Player extends CharacterBody3D

@export var footstep_pitch_min = 0.9
@export var footstep_pitch_max = 1.1
@export var hurt_pitch_min = 0.9
@export var hurt_pitch_max = 1.1
@export var health = 2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var tray_release = false
var losing_balance = false

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var footstep_sfx: AudioStreamPlayer3D = $FootstepSfx
@onready var visual: Node3D = $Visual
@onready var flicker_timer: Timer = $FlickerTimer
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer
@onready var hurt_sfx: AudioStreamPlayer3D = $HurtSfx
@onready var tray: RigidBody3D = $Visual/Roth/roth/GeneralSkeleton/BoneAttachmentLeftHand/Tray

func _ready() -> void:
	animation_tree.active = true
	animation_tree.set("parameters/state_machine/conditions/run", true)
	GameState.player_health = health
	tray.freeze = true
	GameState.start_run = true

func _physics_process(delta: float) -> void:
	handle_movement()
	handle_jump()
	move_and_slide()

func _process(delta):
	update_idle_run_anim()
	check_balance()

func handle_movement():
	if GameState.start_run:
		velocity.z = ((transform.basis.z * Vector3.FORWARD).normalized() * GameState.player_speed).z
	else:
		velocity.z = move_toward(velocity.z, 0, GameState.player_speed)

func update_idle_run_anim():
	if GameState.player_speed > 0:
		if GameState.start_run and not animation_tree.get("parameters/state_machine/conditions/run"):
			animation_tree.set("parameters/state_machine/conditions/run", true)
			animation_tree.set("parameters/state_machine/conditions/idle", false)
		if not GameState.start_run and not animation_tree.get("parameters/state_machine/conditions/idle"):
			animation_tree.set("parameters/state_machine/conditions/idle", true)
			animation_tree.set("parameters/state_machine/conditions/run", false)

func handle_jump():
	if Input.is_action_just_pressed("jump") and not animation_tree.get("parameters/state_machine/conditions/jump"):
		animation_tree.set("parameters/state_machine/conditions/jump", true)

func disable_jump():
	animation_tree.set("parameters/state_machine/conditions/jump", false)

func footstep():
	if not footstep_sfx.playing:
		footstep_sfx.pitch_scale = randf_range(footstep_pitch_min, footstep_pitch_max)
		footstep_sfx.play()

func play_hurt_sfx():
	if not hurt_sfx.playing:
		hurt_sfx.pitch_scale = randf_range(hurt_pitch_min, hurt_pitch_max)
		hurt_sfx.play()

func hurt():
	if not GameState.lose_balance and not GameState.dying and not GameState.game_over and invulnerability_timer.time_left <= 0:
		health -= 1
		GameState.player_health = health
		var cam = get_tree().get_nodes_in_group("camera")[0] as Camera
		if health >= 1:
			GameState.player_hurt = true
			cam.trigger_shake(0.25)
			if not animation_tree.get("parameters/state_machine/conditions/trip"):
				animation_tree.set("parameters/state_machine/conditions/trip", true)
			flicker_timer.start()
			invulnerability_timer.start()
			await invulnerability_timer.timeout
			flicker_timer.stop()
			GameState.player_hurt = false
		else:
			release_tray(Vector3.FORWARD * 3)
			cam.trigger_shake(2)
			GameState.dying = true
			animation_tree.set("parameters/hold_tray_blend/blend_amount", 0.0)
			animation_tree.set("parameters/state_machine/conditions/trip_fall", true)
			await get_tree().create_timer(2).timeout
			GameState.player_speed = 0
			animation_tree.set("parameters/state_machine/conditions/die", true)
			GameState.game_over = true

func disable_trip():
	animation_tree.set("parameters/state_machine/conditions/trip", false)

func _on_flicker_timer_timeout() -> void:
	if visual.visible:
		visual.visible = false
		await get_tree().create_timer(0.1).timeout
		visual.visible = true

func release_tray(force):
	if not tray_release:
		tray_release = true
		var tray_bone_attachment = tray.get_parent()
		var temp_position = tray_bone_attachment.global_position
		tray_bone_attachment.remove_child(tray)
		get_tree().get_nodes_in_group("map")[0].add_child(tray)
		tray.freeze = false
		tray.global_position = temp_position
		animation_tree.set("parameters/hold_tray_blend/blend_amount", 0.0)
		tray.apply_impulse(force * GameState.player_speed)

func check_balance():
	if GameState.lose_balance and not losing_balance:
		GameState.player_speed = 0
		release_tray(Vector3.FORWARD * 3)
		animation_tree.set("parameters/state_machine/conditions/defeat", true)
		await get_tree().create_timer(3.0).timeout
		GameState.game_over = true
