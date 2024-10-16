extends GuardState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)
	
	#animation_player.play("guard_idle")
