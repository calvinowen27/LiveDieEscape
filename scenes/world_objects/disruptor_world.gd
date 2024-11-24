extends RigidBody2D

var _in_use: bool = false

func _ready() -> void:
	$ZOrdering.init($Sprite2D)

func use() -> void:
	_in_use = true

func unuse() -> void:
	_in_use = false

func in_use() -> bool:
	return _in_use
