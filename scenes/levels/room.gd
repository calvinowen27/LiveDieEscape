extends Node

class_name Room

@export var _level_idx: int
@export var _room_idx: int

var _is_valid = true

func get_level_idx() -> int:
	return _level_idx

func get_room_idx() -> int:
	return _room_idx

func set_invalid() -> void:
	_is_valid = false

func is_valid() -> bool:
	return _is_valid
