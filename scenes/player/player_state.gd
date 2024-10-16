extends State

class_name PlayerState

var _rigidbody: RigidBody2D
var _sprite: Sprite2D
var _animation_player: AnimationPlayer

func _ready() -> void:
	_set_curr_state("PlayerIdle")

func enable():
	pass

func state_init() -> void:
	pass

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	if new_state == null:
		return null
	
	manage_endurance_cooldown(new_state_name)
	
	if _curr_state != null:
		var rigidbody = get_parent()
		var sprite = rigidbody.get_node("Sprite2D")
		var animation_player = rigidbody.get_node("AnimationPlayer")
		_curr_state.player_state_enable(sprite, rigidbody, animation_player)

	return new_state

func manage_endurance_cooldown(new_state_name: String) -> void:
	var need_endurance = StatManager.get_stat("endurance") < StatManager.get_base_stat("endurance")
	var endurance_cd_timer = $EnduranceCooldownTimer
	
	if new_state_name != "PlayerRun":
		if need_endurance and endurance_cd_timer.is_stopped():
			endurance_cd_timer.start()
	else:
		endurance_cd_timer.stop()

# enable state and pass necessary references
func player_state_enable(sprite: Sprite2D, rigidbody: RigidBody2D, animation_player: AnimationPlayer) -> void:
	_sprite = sprite
	_rigidbody = rigidbody
	_animation_player = animation_player
	
	super.enable()

# flip sprite depending on move direction, retain last direction
func point_sprite(move_dir: Vector2) -> void:
	if move_dir.x > 0:
		_sprite.scale.x = -1 * abs(_sprite.scale.x)
	elif move_dir.x < 0:
		_sprite.scale.x = 1 * abs(_sprite.scale.x)

func move(speed_mult: float) -> Vector2:
	var move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	var speed = StatManager.get_base_stat("speed")
	_rigidbody.linear_velocity = move_dir * (300 + speed * 20) * speed_mult
	
	return move_dir

func _on_endurance_cooldown_timer_timeout() -> void:
	if _curr_state.name == "PlayerRun":
		return
	
	StatManager.change_stat("endurance", 1)
	
	if StatManager.get_stat("endurance") < StatManager.get_base_stat("endurance"):
		$EnduranceCooldownTimer.start()
