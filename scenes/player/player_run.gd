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
	
	if $EnduranceTimer.is_stopped():
		$EnduranceTimer.start()

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
	if get_parent().get_curr_state() == self:
		StatManager.change_stat("endurance", -1)
		$EnduranceTimer.start()
