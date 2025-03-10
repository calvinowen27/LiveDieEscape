extends GuardState

var _move_dir: Vector2
@export var _move_speed: int

var _player_reset = false

var _level: int
var _room: int

func _ready() -> void:
	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()
	
	EventBus.change_room.connect(_on_room_change)

func update(_delta: float) -> String:
	var player_pos = RoomManager.get_player().global_position
	var speed = 100 + _move_speed * 15

	_move_dir = (player_pos - _rigidbody.global_position).normalized()
	_rigidbody.linear_velocity = _move_dir * speed

	var disruptors = get_tree().get_nodes_in_group("Disruptors")
	for disruptor in disruptors:
		if not disruptor.in_use():
			disruptor.use()
			get_node("../GuardDisrupted").init(disruptor)
			return "GuardDisrupted"

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
