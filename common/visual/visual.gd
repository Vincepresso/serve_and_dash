extends Node3D

var _physics_body_tran_last # Type: Transform2D/3D
var _physics_body_tran_current # Type: Transform2D/3D

func _ready() -> void:
	self.top_level = true

func _physics_process(delta: float) -> void:
	_physics_body_tran_last = _physics_body_tran_current
	_physics_body_tran_current = owner.global_transform

func _process(_delta: float) -> void:
	self.global_transform = \
		_physics_body_tran_last.interpolate_with(
			_physics_body_tran_current,
			Engine.get_physics_interpolation_fraction()
		)
