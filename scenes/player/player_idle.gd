extends PlayerState

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	_animated_sprite.animation = "player_idle"
	_animated_sprite.play()
	
	if StatManager.get_stat("endurance") < StatManager.get_base_stat("endurance"):
		$EnduranceCooldownTimer.start()

func disable() -> void:
	super.disable()
	$EnduranceCooldownTimer.stop()

func update(delta: float) -> String:
	var move_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# movement detected, change to walk state
	if move_vec != Vector2.ZERO:
		return "PlayerWalk"
	
	return name

func _on_endurance_cooldown_timer_timeout() -> void:
	StatManager.change_stat("endurance", 1)
	if StatManager.get_stat("endurance") < StatManager.get_base_stat("endurance"):
		$EnduranceCooldownTimer.start()
