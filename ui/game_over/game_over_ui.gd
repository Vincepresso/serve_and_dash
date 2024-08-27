extends Control

@export var seconds_before_triggered = 2.0

var triggered = false

func _ready() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.visible = false

func _process(delta: float) -> void:
	if GameState.game_over and not triggered:
		triggered = true
		await get_tree().create_timer(seconds_before_triggered).timeout
		self.mouse_filter = Control.MOUSE_FILTER_STOP
		self.visible = true
