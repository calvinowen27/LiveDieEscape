extends State

class_name GuardState

var _rigidbody: RigidBody2D
var _animation_player: AnimationPlayer

func _ready() -> void:
	var rigidbody = get_parent()
	var animation_player = get_node("../AnimationPlayer")
	guard_state_enable(rigidbody, animation_player)

	_set_curr_state("GuardFollowPlayer")

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
