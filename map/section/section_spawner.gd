extends Node3D

@export var section_parts: Array[PackedScene]

func _ready() -> void:
	GameState.next_section_spawn_location = Vector3.ZERO
	spawn()

func _process(delta: float) -> void:
	if GameState.spawn_next_section:
		spawn()

func spawn():
	GameState.spawn_next_section = false
	var section_instance = section_parts.pick_random().instantiate() as Section
	add_child(section_instance)
	section_instance.global_position = GameState.next_section_spawn_location
	#printt("Spawn", section_instance.name, "global_position", str(section_instance.global_position))
	get_tree().call_group("section", "despawn")
