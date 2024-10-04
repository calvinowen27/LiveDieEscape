extends Node

class_name Room

@export var _level_idx: int
@export var _room_idx: int

func get_level_idx() -> int:
	return _level_idx

func get_room_idx() -> int:
	return _room_idx
