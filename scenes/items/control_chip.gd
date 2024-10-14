extends Item

@export var _control_level: int
@export var _control_room: int

func get_control_level() -> int:
	return _control_level

func get_control_room() -> int:
	return _control_room
