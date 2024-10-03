extends PlayerState

var move_dir: Vector2
@export var speed_mult = 2.5

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animated_sprite.animation = "player_run"
	_animated_sprite.play()
	$EnduranceTimer.start()

func disable() -> void:
	super.disable()
	$EnduranceTimer.stop()

func update(delta: float) -> String:
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var speed = StatManager.get_base_stat("speed")
	_rigidbody.linear_velocity = move_dir * (150 + speed * 10) * speed_mult
	
	# flip sprite depending on move direction, retain last direction
	if move_dir.x > 0:
		_animated_sprite.scale.x = -1 * abs(_animated_sprite.scale.x)
	elif move_dir.x < 0:
		_animated_sprite.scale.x = 1 * abs(_animated_sprite.scale.x)
	
	# not moving anymore --> idle
	if move_dir == Vector2.ZERO:
		return "PlayerIdle"
	
	var has_endurance = StatManager.get_stat("endurance") > 0
	
	# not sprinting anymore, but still moving --> walk
	if not Input.is_action_pressed("run") or not has_endurance:
		return "PlayerWalk"
	
	return name

func _on_endurance_timer_timeout() -> void:
	StatManager.change_stat("endurance", -1)
