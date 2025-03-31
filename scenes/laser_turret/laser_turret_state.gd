extends State

class_name LaserTurretState

const TWO_PI = 2*PI

@export var _turret: LaserTurret
@export var _animation_player: AnimationPlayer
@export var _laser_sprite: Sprite2D
@export var _laser_raycast: RayCast2D

var _level: int
var _room: int

func _ready() -> void:
	super._ready()

	_room = RoomManager.get_curr_room_idx()
	_level = RoomManager.get_curr_level()

	EventBus.change_room.connect(_on_room_change)

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		_curr_state.laser_turret_state_enable(_turret, _animation_player, _laser_sprite, _laser_raycast)

	return new_state

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	_turret = turret
	_animation_player = animation_player
	_laser_sprite = laser_sprite
	_laser_raycast = laser_raycast

	_turret.freeze = true
	
	super.enable()

	animation_player.speed_scale = 1

# activate turret when finished priming
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "laser_turret_priming" and _curr_state.name == "LaserTurretPriming":
		_set_curr_state("LaserTurretActivated")
	elif anim_name == "laser_turret_breaking":
		_set_curr_state("LaserTurretBroken")

func _on_room_change(level_idx: int, room_idx: int) -> void:
	if _curr_state == null:
		return

	if level_idx == _level and room_idx == _room and _can_state_change():
		get_parent().disable_turret()
		get_parent().enable_turret()

func start_reboot() -> void:
	if not is_broken():
		_set_curr_state("LaserTurretRebooting")

func end_reboot() -> void:
	if not is_broken() and _curr_state.name == "LaserTurretRebooting":
		_set_curr_state("LaserTurretPriming")
	
func disable_turret() -> void:
	if not is_broken():
		_set_curr_state("LaserTurretIdle")

func enable_turret() -> void:
	if not is_broken():
		_set_curr_state("LaserTurretPriming")

func die() -> void:
	if not is_broken():
		_set_curr_state("LaserTurretBreaking")

func is_broken() -> bool:
	return _curr_state.name == "LaserTurretBreaking" or _curr_state.name == "LaserTurretBroken"

func _can_state_change() -> bool:
	return _curr_state.name != "LaserTurretRebooting" and not is_broken()
