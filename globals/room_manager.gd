extends Node

const ROOM_SCENE_PATH: String = "res://scenes/levels/level_%d/room_%d_%d.tscn"
const ITEM_SCENE_PATH: String = "res://scenes/items/%s.tscn"
const WORLD_OBJ_SCENE_PATH: String = "res://scenes/world_objects/%s.tscn"

@export var _curr_level: int
var _curr_room: Room
var _curr_room_idx: int
var _player: Node2D

var _rooms = {}

var _room_timers = {}

func get_player() -> Node2D:
	return _player

func set_curr_room(level_idx: int, room_idx: int, next_door_idx: int) -> void:
	# get room instance
	var new_room = get_room(level_idx, room_idx)

	_curr_room_idx = room_idx

	_change_room(new_room, next_door_idx)

	# used for things affected by room change
	EventBus.change_room.emit.bind(level_idx, room_idx).call_deferred()

func door_entered(door_idx: int) -> void:
	# RoomManager.set_curr_room(_next_level_idx, _next_room_idx, self)

	var door_info = LevelManager.get_door_info(_curr_room_idx, door_idx)

	set_curr_room(door_info["next_level"], door_info["next_room"], door_info["next_door"])

# change current room for new room in scene tree
func _change_room(new_room: Room, next_door_idx: int):
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
	if next_door_idx != -1:
		var next_door = get_door(next_door_idx)
		move_player_to_door(next_door)
	else:
		try_move_player_to_spawn()

func move_player_to_door(next_door: Door) -> void:
	# spawn location position is relative to parent, global position is what we want
	if next_door != null:
		_player.teleport(next_door.get_spawn_location())

func try_move_player_to_spawn() -> void:
	var player_spawn = _curr_room.get_node("PlayerSpawn")
	if player_spawn != null:
		_player.teleport(player_spawn.position)

func get_door(door_idx: int) -> Door:
	return _curr_room.get_door(door_idx)

# get room node associated with level and room idx, if room doesn't exist, create and store it
func get_room(level_idx: int, room_idx: int) -> Room:
	if level_idx != _curr_level:
		LevelManager.clear_level(_curr_level)
		_curr_level = level_idx
		LevelManager.load_level(level_idx)

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
	var new_room_resource = load(ROOM_SCENE_PATH % [level_idx, level_idx, room_idx])
	var new_room = new_room_resource.instantiate()

	level_rooms[room_idx] = new_room

	return new_room

func reset_room(level_idx: int, room_idx: int) -> void:
	_rooms[level_idx][room_idx].queue_free.call_deferred()
	_rooms[level_idx][room_idx] = null

func guard_reset() -> void:
	reset_room(_curr_level, _curr_room_idx)
	set_curr_room(_curr_level, _curr_room_idx, -1)
	get_player().reset.call_deferred()

	#_player.queue_teleport(_curr_room.get_node("%PlayerResetPos").position);

func instantiate_item(item_name: String, position: Vector2) -> Item:
	var item = load(ITEM_SCENE_PATH % item_name).instantiate()
	
	_curr_room.add_child(item)
	item.position = position
	
	return item

func spawn_object(object_name: String, position: Vector2) -> Node2D:
	var obj = load(WORLD_OBJ_SCENE_PATH % object_name).instantiate()
	_curr_room.add_child(obj)
	obj.position = position
	return obj

func reboot_room(level_idx: int, room_idx: int) -> void:
	_rooms[level_idx][room_idx].start_reboot_room()
	# _rooms[level_idx][room_idx].disable_room()

	_room_timers[room_idx] = get_tree().create_timer(10)

	await _room_timers[room_idx].timeout
	
	# _rooms[level_idx][room_idx].enable_room()
	_rooms[level_idx][room_idx].end_reboot_room()
	_room_timers.erase(room_idx)

func bridge_acid(room_idx: int) -> void:
	var children = get_room(_curr_level, room_idx).get_node("AcidContainer").get_children()
	for child in children:
		if child.is_in_group("Acid") && child.is_bridge_piece():
			child.bridge()
			break

func get_curr_room() -> Room:
	return _curr_room

func get_curr_room_idx() -> int:
	return _curr_room_idx

func get_curr_level() -> int:
	return _curr_level

func get_rooms() -> Dictionary:
	return _rooms

func get_room_timers() -> Dictionary:
	return _room_timers
