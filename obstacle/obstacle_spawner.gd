extends Node3D

@export var spawn_distance = 20.0
@export var obstacle_list: Array[PackedScene]
@export var spawn_points: Node3D

var player

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]

func _process(delta: float) -> void:
	for spawn_point in spawn_points.get_children():
		if spawn_point.global_position.z - player.global_position.z <= spawn_distance:
			spawn(spawn_point)

func spawn(spawn_point):
	if not spawn_point.spawned and obstacle_list:
		var chance = randf_range(0, 1)
		#printt(chance, str(chance <= GameState.obstacle_spawn_chance))
		if chance <= GameState.obstacle_spawn_chance:
			var obstacle_instance = obstacle_list.pick_random().instantiate() as Obstacle
			add_child(obstacle_instance)
			obstacle_instance.position = spawn_point.position
			#printt("Spawn", obstacle_instance.name, "on", spawn_point.name)
		spawn_point.spawned= true
