extends State

class_name LaserTurretState

@export var _animation_player: AnimationPlayer
@export var _laser_sprite: Sprite2D
@export var _laser_raycast: RayCast2D

func _ready() -> void:
	super._ready()

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		_curr_state.laser_turret_state_enable(_animation_player, _laser_sprite, _laser_raycast)

	return new_state

func laser_turret_state_enable(animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	_animation_player = animation_player
	_laser_sprite = laser_sprite
	_laser_raycast = laser_raycast
	
	super.enable()

	animation_player.speed_scale = 1

# activate turret when finished priming
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "laser_turret_priming":
		_set_curr_state("LaserTurretActivated")
	elif anim_name == "laser_turret_breaking":
		_set_curr_state("LaserTurretBroken")

func reboot() -> void:
	_set_curr_state("LaserTurretIdle")
	
	await get_tree().create_timer(10).timeout
	
	if _curr_state.name == "LaserTurretIdle":
		_set_curr_state("LaserTurretPriming")
	
func disable_turret() -> void:
	_set_curr_state("LaserTurretIdle")

func enable_turret() -> void:
	_set_curr_state("LaserTurretPriming")

func die() -> void:
	if _curr_state.name != "LaserTurretBroken" and _curr_state.name != "LaserTurretBreaking":
		_set_curr_state("LaserTurretBreaking")
