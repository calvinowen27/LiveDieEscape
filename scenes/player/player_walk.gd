extends PlayerState

var move_dir: Vector2
@export var speed = 2

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animated_sprite.animation = "player_walk"
	_animated_sprite.play()

func update(delta: float) -> String:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	_rigidbody.linear_velocity = move_dir * (150 + speed * 10)
	
	# flip sprite depending on move direction, retain last direction
	if move_dir.x > 0:
		_animated_sprite.scale.x = -1 * abs(_animated_sprite.scale.x)
	elif move_dir.x < 0:
		_animated_sprite.scale.x = 1 * abs(_animated_sprite.scale.x)
	
	# not moving anymore --> idle
	if move_dir == Vector2.ZERO:
		return "PlayerIdle"
	
	# start running --> run
	if Input.is_action_pressed("run"):
		return "PlayerRun"
	
	return name
