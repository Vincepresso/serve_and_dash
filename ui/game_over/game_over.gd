extends CanvasLayer


func _on_retry_button_pressed() -> void:
	SceneTransition.transition_to(GameState.highway_scene_path)
