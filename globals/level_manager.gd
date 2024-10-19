extends Node

var _level_info = {}

var _curr_level: int

func _ready() -> void:
	load_level(0)

func load_level(level: int):
	# read level file, load each room
	load_level_file(level)
	
	for room in _level_info["rooms"].keys():
		RoomManager.get_room(level, int(room))
	
	_curr_level = level

func load_level_file(level: int):
	var file = FileAccess.open("res://levels.json", FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		_level_info = json.data["level_%d" % level]
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())

func get_door_info(room_idx: int, door_idx: int) -> Dictionary:
	return _level_info["rooms"]["%d" % room_idx]["doors"]["%d" % door_idx]
