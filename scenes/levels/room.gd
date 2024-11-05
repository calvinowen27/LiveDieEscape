extends Node2D

class_name Room

@export var _level_idx: int
@export var _room_idx: int

var _is_valid = true

var _laser_turrets: Array[Node]

func _ready() -> void:
	_laser_turrets = get_tree().get_nodes_in_group("LaserTurrets")

func enable_room() -> void:
	for turret in _laser_turrets:
		turret.enable_turret()

func disable_room() -> void:
	for turret in _laser_turrets:
		turret.disable_turret()

func get_level_idx() -> int:
	return _level_idx

func get_room_idx() -> int:
	return _room_idx

func set_invalid() -> void:
	_is_valid = false

func is_valid() -> bool:
	return _is_valid
