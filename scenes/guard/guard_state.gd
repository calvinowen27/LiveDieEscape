extends State

class_name GuardState

@export var _rigidbody: RigidBody2D
@export var _animation_player: AnimationPlayer

const BASE_SPEED_MULT: int = 20
@export var _move_speed: int
@export var _target_stop_range: int
@export var _base_acceleration: float

var _move_dir: Vector2
var _target_pos: Vector2

func _ready() -> void:
	var rigidbody = get_parent()
	var animation_player = get_node("../AnimationPlayer")
	guard_state_enable(rigidbody, animation_player)

	super._ready()

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		_curr_state.guard_state_enable(_rigidbody, _animation_player)

	return new_state

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	_rigidbody = rigidbody
	_animation_player = animation_player

	super.enable()

func disrupt(disruptor: Disruptor) -> void:
	var new_state = get_node("GuardDisrupted")
	new_state.init(disruptor)
	_set_curr_state("GuardDisrupted")

func move() -> void:
	# move
	_move_dir = (_target_pos - _rigidbody.global_position).normalized()

	# acceleration based movement
	var dist_to_target = (_rigidbody.position - _target_pos).length()

	var acceleration = _base_acceleration

	_rigidbody.linear_velocity += _move_dir * acceleration

	# if close to target position decelerate
	if dist_to_target <= 10:
		_rigidbody.linear_velocity *= dist_to_target / float(10)

	# cap speed
	if _rigidbody.linear_velocity.length() > _move_speed * BASE_SPEED_MULT:
		_rigidbody.linear_velocity = _rigidbody.linear_velocity.normalized() * _move_speed * BASE_SPEED_MULT
	
	# stop if at target
	if dist_to_target <= _target_stop_range:
		_rigidbody.linear_velocity = Vector2.ZERO
	
	# TODO: i feel like this isn't great
	if _rigidbody.linear_velocity.x > 0:
		_animation_player.play("guard_walk_right")
		if not _rigidbody.get_node("WalkSfx2D").playing:
			_rigidbody.get_node("WalkSfx2D").play()
	elif _rigidbody.linear_velocity.x < 0:
		_animation_player.play("guard_walk_left")
		if not _rigidbody.get_node("WalkSfx2D").playing:
			_rigidbody.get_node("WalkSfx2D").play()
	else:
		_animation_player.play("guard_idle")
		_rigidbody.get_node("WalkSfx2D").stop()
