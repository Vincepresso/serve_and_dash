@tool
extends EditorScenePostImport

var mat = load("res://assets/models/icons/icons_textures/icon_mat_01.tres")

func _post_import(scene: Node):
	_apply_default_material(scene)
	return scene

func _apply_default_material(node: Node):
	var mesh_node: MeshInstance3D = node.get_child(0)
	mesh_node.set_surface_override_material(0, mat)
