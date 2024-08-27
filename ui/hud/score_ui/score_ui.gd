extends Control

@onready var score_value: Label = $HBoxContainer/ScoreValue

func _process(delta: float) -> void:
	score_value.text = str(GameState.score)
