extends Node

const LEVEL_FILE_PATH: String = "res://levels.json"

var _level_info = {}

var _curr_level: int

func _ready() -> void:
	EventBus.level_reset.connect(_on_level_reset)

	load_level(0)

func load_level(level: int):
	# read level file, load each room
	load_level_file(level)
	
	for room in _level_info["rooms"].keys():
		RoomManager.get_room(level, int(room))
	
	_curr_level = level

# load level file into _level_info dictionary
func load_level_file(level: int):
	var file = FileAccess.open(LEVEL_FILE_PATH, FileAccess.READ)
	var content = file.get_as_text()

	var json = JSON.new()
	var error = json.parse(content)
	if error == OK:
		_level_info = json.data["level_%d" % level]
	else:
		print("level_manager ~ JSON Parse Error: ", json.get_error_message(), " in ", json.dat, " at line ", json.get_error_line())

func _on_level_reset(level_idx: int) -> void:
	clear_level(level_idx)

	RoomManager.set_curr_room(level_idx, 0, -1)

	StatManager.reset_stats()

func clear_level(level_idx: int) -> void:
	var rooms = RoomManager.get_rooms()
	if RoomManager.get_curr_level() not in rooms.keys():
		print_debug("reset_level(): level %d not loaded yet?" % level_idx)
		return

	# invalidate all rooms in level for out of sync calls
	# free rooms
	for room in rooms[level_idx]:
		if room != null:
			room.set_invalid()
			room.queue_free()

	# reset rooms list and reset room to default
	rooms[level_idx].clear()

func get_door_info(room_idx: int, door_idx: int) -> Dictionary:
	return _level_info["rooms"]["%d" % room_idx]["doors"]["%d" % door_idx]
