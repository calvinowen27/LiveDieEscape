extends GuardState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	if _rigidbody.player_in_range():
		return "GuardFollowPlayer"

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)
	
	#animation_player.play("guard_idle")

	rigidbody.linear_velocity = Vector2.ZERO

