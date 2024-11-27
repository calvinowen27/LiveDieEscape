extends PlayerState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animation_player.play("player_idle_left")

func update(_delta: float) -> String:
	var move_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	if get_node("../../").get_last_move_dir().x > 0:
		_animation_player.play("player_idle_right")
	else:
		_animation_player.play("player_idle_left")
	
	# movement detected, change to walk state
	if move_vec != Vector2.ZERO:
		return "PlayerWalk"
	
	if Input.is_action_pressed("run") and _can_dash:
		_can_dash = false
		get_node("../DashCooldownTimer").start()
		return "PlayerDash"
	
	return name

func _on_dash_cooldown_timer_timeout() -> void:
	_can_dash = true
