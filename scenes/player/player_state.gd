extends State

class_name PlayerState

var _rigidbody: RigidBody2D
var _animated_sprite: AnimatedSprite2D

func _ready() -> void:
	_set_curr_state(get_node("PlayerIdle"))

func _process(delta: float) -> void:
	if _curr_state != null:
		var next_state_name = _curr_state.update(delta)
		if next_state_name != _curr_state.name:
			_set_curr_state(get_node(next_state_name))

func enable():
	pass

func state_init() -> void:
	pass

func _set_curr_state(new_state: State) -> void:
	super._set_curr_state(new_state)
	
	var need_endurance = StatManager.get_stat("endurance") < StatManager.get_base_stat("endurance")
	var endurance_cd_timer = $EnduranceCooldownTimer
	
	if new_state.name != "PlayerRun":
		if need_endurance and endurance_cd_timer.is_stopped():
			endurance_cd_timer.start()
	else:
		endurance_cd_timer.stop()
	
	if _curr_state != null:
		_curr_state.player_enable(get_parent(), get_parent().get_node("AnimatedSprite2D"))

func get_curr_state() -> PlayerState:
	return _curr_state

func player_enable(rigidbody: RigidBody2D, animated_sprite: AnimatedSprite2D) -> void:
	_rigidbody = rigidbody
	_animated_sprite = animated_sprite
	
	super.enable()

# flip sprite depending on move direction, retain last direction
func point_sprite(move_dir: Vector2) -> void:
	if move_dir.x > 0:
		_animated_sprite.scale.x = -1 * abs(_animated_sprite.scale.x)
	elif move_dir.x < 0:
		_animated_sprite.scale.x = 1 * abs(_animated_sprite.scale.x)

func move(speed_mult: float) -> Vector2:
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var speed = StatManager.get_base_stat("speed")
	_rigidbody.linear_velocity = move_dir * (150 + speed * 10) * speed_mult
	
	return move_dir

func _on_endurance_cooldown_timer_timeout() -> void:
	if _curr_state.name == "PlayerRun":
		return
	
	StatManager.change_stat("endurance", 1)
	
	if StatManager.get_stat("endurance") < StatManager.get_base_stat("endurance"):
		$EnduranceCooldownTimer.start()
