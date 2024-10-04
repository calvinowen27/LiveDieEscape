extends Node

@export var _curr_level: int
var _curr_room: Room
var _player: Node2D

func get_player() -> Node2D:
	return _player

func set_curr_room(level_idx: int, room_idx: int) -> void:
	var new_room_resource = load("res://scenes/levels/level_%d/room_%d_%d.tscn" % [level_idx, level_idx, room_idx])
	var new_room = new_room_resource.instantiate()
	
	print(SceneManager.get_curr_scene())
	
	var game_rect = SceneManager.get_curr_scene().get_node("%GameRect")
	if game_rect == null:
		print_debug("set_curr_room(): failed to set room (GameRect null)")
		return
	
	if _curr_room != null:
		game_rect.remove_child(_curr_room)
	
	game_rect.add_child(new_room)
	_curr_room = new_room
	_player = _curr_room.get_node("Player")
	print("room set successfully")

func get_curr_room() -> Room:
	return _curr_room
