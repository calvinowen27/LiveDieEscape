extends GuardState

var _move_dir: Vector2
@export var _move_speed: int

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	var player_pos = RoomManager.get_player().global_position
	var speed = 100 + _move_speed * 15

	_move_dir = (player_pos - _rigidbody.global_position).normalized()
	_rigidbody.linear_velocity = _move_dir * speed

func guard_state_enable(rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.guard_state_enable(rigidbody, animation_player)
	#animation_player.play("guard_walk")
