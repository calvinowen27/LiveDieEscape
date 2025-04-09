extends GuardState

var _move_dir: Vector2
@export var _move_speed: int

@export var _target_stop_range: int

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
	
	# return to key if the player is far enough away or key is out of range
	if not _rigidbody.key_picked_up() and (not _rigidbody.player_in_range()  or not _rigidbody.key_in_range()):
		return "GuardReturn"

	update_target_pos()

	# move
	# var speed = 100 + _move_speed * 15
	_move_dir = (_target_pos - _rigidbody.global_position).normalized()
	# if (_rigidbody.position - _target_pos).length() <= _target_stop_range:
	# 	_rigidbody.linear_velocity = Vector2.ZERO
	# else:
	# 	_rigidbody.linear_velocity = _move_dir * speed

	var acceleration = 5
	var dist_to_target = (_rigidbody.position - _target_pos).length()
	if dist_to_target <= 25:
			acceleration *= -int(25 / dist_to_target)

	_rigidbody.linear_velocity += _move_dir * acceleration

	if _rigidbody.linear_velocity.length() > 100 + _move_speed * 15:
		_rigidbody.linear_velocity = _rigidbody.linear_velocity.normalized() * (100 + _move_speed * 15)

	if dist_to_target <= _target_stop_range:
		_rigidbody.linear_velocity = Vector2.ZERO

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

func _on_guard_body_entered(body: Node) -> void:
	if body == RoomManager.get_player() and not _player_reset:
		_player_reset = true
		
		# reset the guard and player position
		var reset_marker = get_node("../../../GuardResetPos")
		if reset_marker != null:
			_rigidbody.queue_teleport(reset_marker.position)
		
		RoomManager.guard_reset()

func _on_room_change(level_idx: int, room_idx: int) -> void:
	# if this room, player reset is over
	if level_idx == _level and room_idx == _room:
		_player_reset = false

func update_target_pos() -> Vector2:
	var player = RoomManager.get_player()

	# go to player if key is gone, otherwise go between player and key
	if _rigidbody.key_picked_up():
		_target_pos = player.position
	else:
		_target_pos = player.position + ((_rigidbody.get_key().position - player.position) / 2)
	
	# just for testing
	get_node("../../Polygon2D").global_position = _target_pos
	return _target_pos
