extends Node

@export var _curr_level: int
var _curr_room: Room
var _curr_room_idx: int
var _player: Node2D

var _rooms = {}

func get_player() -> Node2D:
	return _player

func set_curr_room(level_idx: int, room_idx: int, door: Door) -> void:
	# get room instance
	var new_room = _get_room(level_idx, room_idx)
	
	_curr_room_idx = room_idx
	
	change_room(new_room, door)
	
	EventBus.change_room.emit.bind(level_idx, room_idx).call_deferred()

func change_room(new_room: Room, door: Door):
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
	
	if door != null:
		var next_door = get_door(door.get_next_door())
		move_player_to_door(next_door)
		_player.position = next_door.get_node("SpawnLocation").global_position

func move_player_to_door(next_door: Door) -> void:
	_player.position = next_door.get_node("SpawnLocation").global_position

func get_door(door_idx: int) -> Door:
	return _curr_room.get_node("Door%d" % door_idx)

func _get_room(level_idx: int, room_idx: int) -> Node:
	if level_idx in _rooms.keys():
		var level_rooms = _rooms[level_idx]
		if room_idx < level_rooms.size():
			var room = _rooms[level_idx][room_idx]
			if room != null:
				return room
	else:
		# level not seen yet
		_rooms[level_idx] = []
	
	var level_rooms = _rooms[level_idx]
	
	# if level not seen, room not seen
	# if level and room seen this is skipped
	while room_idx >= level_rooms.size():
		level_rooms.append(null)
	
	var new_room_resource = load("res://scenes/levels/level_%d/room_%d_%d.tscn" % [level_idx, level_idx, room_idx])
	var new_room = new_room_resource.instantiate()
	
	level_rooms[room_idx] = new_room
	
	return new_room

func get_curr_room() -> Room:
	return _curr_room

func get_curr_room_idx() -> int:
	return _curr_room_idx
