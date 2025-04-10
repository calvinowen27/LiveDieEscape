extends GuardState

var _move_dir: Vector2
@export var _move_speed: int

var _reset_pos: Vector2

@export var _follow_reset_range: int
@export var _idle_reset_range: int

func _ready() -> void:
	pass

func update(_delta: float) -> String:
	# check for disruption
	if _disruptor_found():
		return "GuardDisrupted"
	
	if _rigidbody.key_picked_up():
		return "GuardFollowPlayer"

	# close enough to reset pos to follow player again? idle?
	var dist_to_reset = (_reset_pos - _rigidbody.position).length()
	if dist_to_reset <= _follow_reset_range and _rigidbody.player_in_range() and _rigidbody.key_in_range():
		return "GuardFollowPlayer"
	elif dist_to_reset <= _idle_reset_range:
		return "GuardIdle"
	
	# move
	_move_dir = (_reset_pos - _rigidbody.position).normalized()
	var speed = 100 + _move_speed * 15
	_rigidbody.linear_velocity = _move_dir * speed

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

	_reset_pos = get_node("../../../GuardResetPos").position
