extends GuardState

var _player_reset: bool = false

var _level: int
var _room: int

func _ready() -> void:
	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()
	
	EventBus.change_room.connect(_on_room_change)

func update(_delta: float) -> String:
	# return to item if the player is far enough away or item is out of range
	if not _rigidbody.item_picked_up() and (not _rigidbody.player_in_range()  or not _rigidbody.item_in_range()):
		return "GuardReturn"

	update_target_pos()

	move()

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

func _on_guard_body_entered(body: Node) -> void:
	if body == RoomManager.get_player(): # and not _player_reset: TODO: figure this out
		_player_reset = true
		
		var item = _rigidbody.get_item()
		if item != null and Inventory.contains_item(item):
			Inventory.del_item(item)

		# reset the guard position
		_rigidbody.queue_reset()

		# resets the player position and room
		RoomManager.guard_reset()

func _on_room_change(level_idx: int, room_idx: int) -> void:
	# if this room, player reset is over
	if level_idx == _level and room_idx == _room:
		_player_reset = false

func update_target_pos() -> Vector2:
	var player = RoomManager.get_player()

	# go to player if item is gone, otherwise go between player and item
	if _rigidbody.item_picked_up():
		_target_pos = player.position
	else:
		_target_pos = player.position + ((_rigidbody.get_item().position - player.position) / 2)
	
	# just for testing
	# get_node("../../Polygon2D").global_position = _target_pos
	return _target_pos
