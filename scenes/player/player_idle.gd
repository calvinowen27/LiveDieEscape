extends PlayerState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()

	var last_move_dir = get_node("../../").get_last_move_dir()

	_play_animation(_animation_player, last_move_dir)

func update(_delta: float) -> String:
	var move_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")

	var last_move_dir = get_node("../../").get_last_move_dir()

	_play_animation(_animation_player, last_move_dir)
	
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

func _play_animation(animation_player: AnimationPlayer, move_dir: Vector2) -> void:
	if move_dir.y > 0:
		animation_player.play("player_idle_down")
	elif move_dir.y < 0:
		animation_player.play("player_idle_up")
	else:
		if move_dir.x > 0:
			animation_player.play("player_idle_right")
		else:
			animation_player.play("player_idle_left")
