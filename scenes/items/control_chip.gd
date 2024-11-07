extends Item

@export var _control_level: int
@export var _control_room: int

func _ready() -> void:
	_item_info = "Level: 0 Room: 0"

	super._ready()

func set_control_level(control_level: int) -> void:
	_control_level = control_level

func set_control_room(control_room: int) -> void:
	_control_room = control_room

func set_control(control_level: int, control_room: int) -> void:
	_control_level = control_level
	_control_room = control_room

	_item_info = "Level: %d Room: %d" % [_control_level, _control_room]

func get_control_level() -> int:
	return _control_level

func get_control_room() -> int:
	return _control_room
