extends PlayerState

@export var speed_mult = 10
@export var dash_ticks = 10
var _dash_ticks_elapsed = 0

var _dashing = false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animation_player.play("dash_left_test")

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.player_state_enable(sprite, rigidbody, animation_player)

	_dash_ticks_elapsed = 0
	_dashing = true

func update(_delta: float) -> String:
	if dash().x > 0:
		_animation_player.play("player_dash_right")
	else:
		_animation_player.play("player_dash_left")
	
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
	var dash_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if dash_dir == Vector2.ZERO:
		dash_dir = get_node("../../").get_last_move_dir()
	
	var speed = StatManager.get_base_stat("speed")
	_rigidbody.linear_velocity = dash_dir * (300 + speed * 20) * speed_mult

	return dash_dir
