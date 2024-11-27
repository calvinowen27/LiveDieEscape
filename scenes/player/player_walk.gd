extends PlayerState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func state_init() -> void:
	super.state_init()
	
	_animation_player.play("player_walk_left")

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	super.player_state_enable(sprite, rigidbody, animation_player)

func update(_delta: float) -> String:
	move(1)
	# point_sprite()

	if _move_dir.x > 0:
		_animation_player.play("player_walk_right")
	else:
		_animation_player.play("player_walk_left")

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
