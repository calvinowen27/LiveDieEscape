extends GuardState

var _move_dir: Vector2
@export var _move_speed: int

var _disruptor: Node2D

func init(disruptor: Node2D) -> void:
	_disruptor = disruptor

func _ready() -> void:
	pass

func update(_delta: float) -> String:
	if _disruptor == null:
		return "GuardFollowPlayer"

	var target_pos = _disruptor.position
	var speed = 100 + _move_speed * 15

	_move_dir = (target_pos - _rigidbody.global_position).normalized()
	_rigidbody.linear_velocity = _move_dir * speed

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

func _on_guard_body_entered(body: Node) -> void:
	if body == _disruptor:
		body.queue_free()
		_disruptor = null
		
