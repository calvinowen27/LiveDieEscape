extends PlayerState

@export var dash_speed_mult = 5
@export var dash_ticks = 10
var _dash_ticks_elapsed = 0

var _dashing = false
var _dash_dir: Vector2

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.player_state_enable(sprite, rigidbody, animation_player)

	_animation_player.play("player/player_dash_left")

	_dash_ticks_elapsed = 0
	_dashing = true

	# set dash direction based on input or last movement direction
	_dash_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if _dash_dir == Vector2.ZERO:
		_dash_dir = _rigidbody.get_last_move_dir()

func update(_delta: float) -> String:
	if dash().x > 0:
		_animation_player.play("player/player_dash_right")
	else:
		_animation_player.play("player/player_dash_left")
	
	if _dash_ticks_elapsed < dash_ticks and _dashing:
		_dash_ticks_elapsed += 1
	else:
		_dashing = false
		_rigidbody.linear_velocity = Vector2.ZERO
		
		if _move_dir == Vector2.ZERO:
			return "PlayerIdle"
		
		return "PlayerWalk"
	
	return name

func dash() -> Vector2:
	var speed = StatManager.get_stat("speed")
	var speed_mult = StatManager.get_stat("speed_mult")

	_rigidbody.linear_velocity = _dash_dir * (speed * BASE_SPEED_MULT) * speed_mult * dash_speed_mult

	return _dash_dir
