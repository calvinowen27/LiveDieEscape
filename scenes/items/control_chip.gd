extends Item

@export var _control_level: int
@export var _control_room: int

func set_control_level(control_level: int) -> void:
	_control_level = control_level

func set_control_room(control_room: int) -> void:
	_control_room = control_room

func get_control_level() -> int:
	return _control_level

func get_control_room() -> int:
	return _control_room
