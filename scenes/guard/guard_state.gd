extends State

class_name GuardState

var _rigidbody: RigidBody2D
var _animation_player: AnimationPlayer

var _player_reset = false

func _ready() -> void:
	var rigidbody = get_parent()
	var animation_player = get_node("../AnimationPlayer")
	guard_state_enable(rigidbody, animation_player)

	_set_curr_state("GuardFollowPlayer")

	EventBus.change_room.connect(_on_room_change)

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		var rigidbody = get_parent()
		var animation_player = get_node("../AnimationPlayer")
		_curr_state.guard_state_enable(rigidbody, animation_player)

	return new_state

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	_rigidbody = rigidbody
	_animation_player = animation_player

	super.enable()

func _on_guard_body_entered(body: Node) -> void:
	if body == RoomManager.get_player() and not _player_reset:
		_player_reset = true
		var reset_marker = get_node("../../GuardResetPos")
		if reset_marker != null:
			_rigidbody.global_position = reset_marker.global_position
		
		RoomManager.guard_reset.call_deferred()

func _on_room_change(level_idx: int, room_idx: int) -> void:
	_player_reset = false
