extends Node

@export var _curr_level: int
var _curr_room: Room
var _curr_room_idx: int
var _player: Node2D

var _rooms = {}

func _ready() -> void:
	EventBus.level_reset.connect(_on_level_reset)

func get_player() -> Node2D:
	return _player

func set_curr_room(level_idx: int, room_idx: int, door: Door) -> void:
	# get room instance
	var new_room = get_room(level_idx, room_idx)

	_curr_room_idx = room_idx

	_change_room(new_room, door)

	# used for things affected by room change
	EventBus.change_room.emit.bind(level_idx, room_idx).call_deferred()

# change current room for new room in scene tree
func _change_room(new_room: Room, door: Door):
	# game rect is parent of room
	var game_rect = SceneManager.get_curr_scene().get_node("%GameRect")
	if game_rect == null:
		print_debug("set_curr_room(): failed to set room (GameRect null)")
		return

	if _curr_room != null:
		game_rect.remove_child.bind(_curr_room).call_deferred()

	# change out rooms
	game_rect.add_child.bind(new_room).call_deferred()
	_curr_room = new_room
	_player = _curr_room.get_node("Player")

	# move player to next door start position
	if door != null:
		var next_door = get_door(door.get_next_door_idx())
		move_player_to_door(next_door)

func move_player_to_door(next_door: Door) -> void:
	# spawn location position is relative to parent, global position is what we want
	_player.position = next_door.get_node("SpawnLocation").global_position

func get_door(door_idx: int) -> Door:
	return _curr_room.get_node("Door%d" % door_idx)

# get room node associated with level and room idx, if room doesn't exist, create and store it
func get_room(level_idx: int, room_idx: int) -> Node:
	var level_rooms
	if level_idx in _rooms.keys():
		level_rooms = _rooms[level_idx]
		if room_idx < level_rooms.size():
			var room = _rooms[level_idx][room_idx]
			if room != null:
				return room
	else:
		# level not seen yet
		_rooms[level_idx] = []

	level_rooms = _rooms[level_idx]

	# if level not seen, room not seen
	# if level seen and room not seen, make sure list is large enough for room
	# if level and room seen this is skipped
	while room_idx >= level_rooms.size():
		level_rooms.append(null)

	# load and instantiate appropriate room
	var new_room_resource = load("res://scenes/levels/level_%d/room_%d_%d.tscn" % [level_idx, level_idx, room_idx])
	var new_room = new_room_resource.instantiate()

	level_rooms[room_idx] = new_room

	return new_room

func _on_level_reset(level_idx: int) -> void:
	if level_idx not in _rooms.keys():
		print_debug("reset_level(): level %d not loaded yet?" % level_idx)
		return

	# invalidate all rooms in level for out of sync calls
	# free rooms
	for room in _rooms[level_idx]:
		room.set_invalid()
		room.queue_free()

	# reset rooms list and reset room to default
	_rooms[level_idx].clear()
	set_curr_room(level_idx, 0, null)

	StatManager.reset_stats()

func get_curr_room() -> Room:
	return _curr_room

func get_curr_room_idx() -> int:
	return _curr_room_idx

func get_curr_level() -> int:
	return _curr_level
