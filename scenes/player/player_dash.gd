extends PlayerState

var move_dir: Vector2
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
	_animation_player.play("player_run")

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.player_state_enable(sprite, rigidbody, animation_player)

	_dash_ticks_elapsed = 0
	_dashing = true

func update(_delta: float) -> String:
	move_dir = move(speed_mult)
	point_sprite(move_dir)
	
	# not moving anymore --> idle
	if move_dir == Vector2.ZERO:
		return "PlayerIdle"
	
	if _dash_ticks_elapsed < dash_ticks and _dashing:
		_dash_ticks_elapsed += 1
	else:
		_dashing = false
		return "PlayerWalk"
	
	return name
