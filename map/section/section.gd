class_name Section extends Node3D

@export var despawn_distance = 10.0

@onready var spawn_trigger: Area3D = $SpawnTrigger
@onready var section_end: Node3D = $SectionEnd

func _ready() -> void:
	add_to_group("section")

func _on_spawn_trigger_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameState.spawn_next_section = true
		GameState.next_section_spawn_location = section_end.global_position

func despawn():
	var distance_from_player = section_end.global_position.z - get_tree().get_nodes_in_group("player")[0].global_position.z
	if distance_from_player >= despawn_distance:
		#printt("Despawn", name)
		queue_free()
