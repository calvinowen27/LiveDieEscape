extends GuardState

var _reset_pos: Vector2

@export var _follow_reset_range: int
@export var _idle_reset_range: int

func _ready() -> void:
	pass

func update(_delta: float) -> String:
	# check for disruption
	if _disruptor_found():
		return "GuardDisrupted"
	
	if _rigidbody.item_picked_up():
		return "GuardFollowPlayer"

	# close enough to reset pos to follow player again? idle?
	var dist_to_reset = (_reset_pos - _rigidbody.position).length()
	if dist_to_reset <= _follow_reset_range and _rigidbody.player_in_range() and _rigidbody.item_in_range():
		return "GuardFollowPlayer"
	elif dist_to_reset <= _idle_reset_range:
		return "GuardIdle"
	
	move()

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

	_reset_pos = _rigidbody.get_start_pos()
	_target_pos = _reset_pos
