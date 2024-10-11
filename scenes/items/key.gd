extends Item

@export var _level: int
@export var _room: int
@export var _door: int

func get_level() -> int:
	return _level

func get_room() -> int:
	return _room

func get_door() -> int:
	return _door

func unlocks_door(level: int, room: int, door: int) -> bool:
	return level == _level and room == _room and door == _door
