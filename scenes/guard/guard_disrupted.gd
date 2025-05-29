extends GuardState

var _disruptor: Node2D

func init(disruptor: Node2D) -> void:
	_disruptor = disruptor
	_target_pos = _disruptor.position

func _ready() -> void:
	pass

func update(_delta: float) -> String:
	if _disruptor == null:
		return "GuardFollowPlayer"

	move()

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)

func _on_guard_body_entered(body: Node) -> void:
	if body is Disruptor:
		body.die()
		_disruptor = null
		
