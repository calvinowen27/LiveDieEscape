extends PlayerState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, character: CharacterBody2D, animation_player: AnimationPlayer) -> void:
	super.player_state_enable(sprite, character, animation_player)

	var last_move_dir = character.get_last_move_dir()
	
	_play_animation(_animation_player, last_move_dir)

func update(_delta: float) -> String:
	move()

	_play_animation(_animation_player, _move_dir)

	# not moving anymore --> idle
	if _move_dir == Vector2.ZERO:
		return "PlayerIdle"
	
	if Input.is_action_pressed("run") and _can_dash:
		_can_dash = false
		get_node("../DashCooldownTimer").start()
		return "PlayerDash"
	
	return name

func _on_dash_cooldown_timer_timeout() -> void:
	_can_dash = true

func _play_animation(animation_player: AnimationPlayer, move_dir: Vector2) -> void:
	if move_dir.y > 0:
		if move_dir.x > 0:
			animation_player.play("player/player_walk_right")
		elif move_dir.x < 0:
			animation_player.play("player/player_walk_left")
		else:
			animation_player.play("player/player_walk_down")
	elif move_dir.y < 0:
		if move_dir.x > 0:
			animation_player.play("player/player_walk_up_right")
		elif move_dir.x < 0:
			animation_player.play("player/player_walk_up_left")
		else:
			animation_player.play("player/player_walk_up")
	else:
		if move_dir.x > 0:
			animation_player.play("player/player_walk_right")
		else:
			animation_player.play("player/player_walk_left")
