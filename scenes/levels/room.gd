extends Node2D

class_name Room

@export var _level_idx: int
@export var _room_idx: int

@export var _dimensions: Vector2

var _is_valid = true

@onready var _laser_turrets: Array[Node] = %LaserTurrets.get_children()

func _ready() -> void:
	# _laser_turrets = %LaserTurrets.get_children()

	var control_points = get_tree().get_nodes_in_group("ControlPoints")
	for point in control_points:
		point.init()

func get_level_idx() -> int:
	return _level_idx

func get_room_idx() -> int:
	return _room_idx

func set_invalid() -> void:
	_is_valid = false

func is_valid() -> bool:
	return _is_valid

func get_dimensions() -> Vector2:
	return _dimensions

func get_width() -> float:
	return _dimensions.x

func get_height() -> float:
	return _dimensions.y

func get_laser_turrets() -> Array[Node]:
	return _laser_turrets
