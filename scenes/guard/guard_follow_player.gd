extends GuardState

var _move_dir: Vector2
@export var _move_speed: int

var _target_pos: Vector2

var _key_in_range: bool = true
var _player_in_range: bool = false
var _key_picked_up: bool = false

var _following_player: bool = false

var _player_reset: bool = false

var _level: int
var _room: int

func _ready() -> void:
	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()
	
	EventBus.change_room.connect(_on_room_change)

func update(_delta: float) -> String:
	# var player_pos = RoomManager.get_player().global_position
	
	if _key_picked_up:
		_following_player = true
	else:
		if _rigidbody.get_key().is_picked_up():
			_key_picked_up = true

	var reset_marker = get_node("../../../GuardResetPos")

	if not _player_in_range and not _key_picked_up and _target_pos == reset_marker.position and (_rigidbody.position - reset_marker.position).length() <= 3:
		return "GuardIdle"

	var speed = 100 + _move_speed * 15
	
	if _following_player:
		# _target_pos = RoomManager.get_player().position
		set_player_follow_pos()

	_move_dir = (_target_pos - _rigidbody.global_position).normalized()
	if (_rigidbody.position - _target_pos).length() <= 3:
		_rigidbody.linear_velocity = Vector2.ZERO
	else:
		_rigidbody.linear_velocity = _move_dir * speed

	var disruptors = get_tree().get_nodes_in_group("Disruptors")
	for disruptor in disruptors:
		if not disruptor.in_use():
			disruptor.use()
			get_node("../GuardDisrupted").init(disruptor)
			return "GuardDisrupted"
	
	if _target_pos == reset_marker.position and _key_in_range and _player_in_range and (_rigidbody.position - reset_marker.position).length() <= 3:
		# _target_pos = RoomManager.get_player().position
		set_player_follow_pos()
		_following_player = true
	# if not _player_in_range:
	# 	_target_pos = reset_marker.position

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)
	#animation_player.play("guard_walk")

func _on_guard_body_entered(body: Node) -> void:
	if body == RoomManager.get_player() and not _player_reset:
		_player_reset = true
		
		var reset_marker = get_node("../../../GuardResetPos")
		if reset_marker != null:
			get_node("../../").queue_teleport(reset_marker.position)
		
		RoomManager.guard_reset()

func _on_room_change(level_idx: int, room_idx: int) -> void:
	if level_idx == _level and room_idx == _room:
		_player_reset = false

func _on_guard_area_body_entered(body: Node) -> void:
	if body == RoomManager.get_player():
		_player_in_range = true

		if _key_in_range or _key_picked_up:
			# _target_pos = body.position
			_following_player = true
		else:
			var reset_marker = get_node("../../../GuardResetPos")
			_target_pos = reset_marker.position
			_following_player = false

func _on_guard_area_body_exited(body: Node) -> void:
	if body == RoomManager.get_player():
		if not _key_picked_up:
			_player_in_range = false
			_following_player = false

			var reset_marker = get_node("../../../GuardResetPos")
			_target_pos = reset_marker.position

func _on_guard_area_area_entered(area: Area2D) -> void:
	if _rigidbody != null and area == _rigidbody.get_key():
		_key_in_range = true
		# if _player_in_range:
		# 	_target_pos = RoomManager.get_player().position

func _on_guard_area_area_exited(area: Area2D) -> void:
	if _rigidbody != null and area == _rigidbody.get_key():
		if _rigidbody.get_key().is_picked_up():
			_key_picked_up = true
			return
		
		_key_in_range = false
		_following_player = false
		var reset_marker = get_node("../../../GuardResetPos")
		_target_pos = reset_marker.position

func set_player_follow_pos() -> Vector2:
	var player = RoomManager.get_player()
	if _key_picked_up:
		_target_pos = player.position
	else:
		_target_pos = player.position + ((_rigidbody.get_key().position - player.position) / 2)
	get_node("../../Polygon2D").global_position = _target_pos
	return _target_pos
