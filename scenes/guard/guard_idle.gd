extends GuardState

var _player_in_range: bool = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(_delta: float) -> String:
	if _player_in_range:
		return "GuardFollowPlayer"

	return name

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)
	
	#animation_player.play("guard_idle")

	rigidbody.linear_velocity = Vector2.ZERO

func _on_guard_area_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_player_in_range = true

func _on_guard_area_body_exited(body: Node2D) -> void:
	if body == RoomManager.get_player():
		_player_in_range = false
