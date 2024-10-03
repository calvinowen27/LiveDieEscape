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
	move_dir = move(speed_mult)
	point_sprite(move_dir)
	
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
	$EnduranceTimer.start()
