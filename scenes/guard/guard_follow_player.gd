extends GuardState

const BASE_SPEED_MULT: int = 20

var _move_dir: Vector2

@export var _move_speed: int
@export var _target_stop_range: int
@export var _base_acceleration: float

var _target_pos: Vector2

var _player_reset: bool = false

var _level: int
var _room: int

func _ready() -> void:
	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()
	
	EventBus.change_room.connect(_on_room_change)

func update(_delta: float) -> String:
	if _disruptor_found():
		return "GuardDisrupted"
	
	# return to item if the player is far enough away or item is out of range
	if not _rigidbody.item_picked_up() and (not _rigidbody.player_in_range()  or not _rigidbody.item_in_range()):
		return "GuardReturn"

	update_target_pos()

	# move
	_move_dir = (_target_pos - _rigidbody.global_position).normalized()

	# acceleration based movement
	var dist_to_target = (_rigidbody.position - _target_pos).length()

	var acceleration = _base_acceleration

	# if close to target position decelerate
	if dist_to_target <= 5:
		acceleration *= -int(5 / dist_to_target)
	
	_rigidbody.linear_velocity += _move_dir * acceleration

	# cap speed
	if _rigidbody.linear_velocity.length() > _move_speed * BASE_SPEED_MULT:
		_rigidbody.linear_velocity = _rigidbody.linear_velocity.normalized() * _move_speed * BASE_SPEED_MULT

	if absf(_rigidbody.linear_velocity.normalized().angle_to_point(_target_pos)) > PI/4:
		_rigidbody.linear_velocity = _move_dir * acceleration

	# stop if at target
	if dist_to_target <= _target_stop_range:
		_rigidbody.linear_velocity = Vector2.ZERO

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

func _on_guard_body_entered(body: Node) -> void:
	if body == RoomManager.get_player() and not _player_reset:
		_player_reset = true
		
		# reset the guard and player position
		_rigidbody.queue_reset()
		
		var item = _rigidbody.get_item()
		if item != null and Inventory.contains_item(item):
			Inventory.del_item(item)

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
