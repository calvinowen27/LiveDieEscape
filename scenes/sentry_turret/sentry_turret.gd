extends RigidBody2D

const _projectile = preload("res://scenes/sentry_turret/projectile.tscn")
const TWO_PI = 2*PI

# wow. just wow.
@export var _track_player: bool = true
@export var _oscillate: bool = false
@export var _oscillate_speed: float
var _oscillate_start_pos: Vector2
@export var _oscillate_end_pos: Vector2
var _reverse_oscillation: bool = false
var _oscillate_dist: float = 0
var _distance_traveled: float = 0
var _oscillate_dir: Vector2

@export var _setup_rotation: int = 0

func _ready() -> void:
	$ZOrdering.init($Sprite2D)

	_oscillate_dist = position.distance_to(_oscillate_end_pos)
	_oscillate_start_pos = position
	_oscillate_dir = (_oscillate_end_pos - _oscillate_start_pos).normalized()

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot()

func _process(_delta: float) -> void:
	var rotation_rads
	var sprite_rotation
	var proj_rotation

	if _track_player:
		var rot_dir = (RoomManager.get_player().global_position - global_position).normalized()
		rotation_rads = atan2(-rot_dir.y, rot_dir.x)
		# + PI to account for negatives
		# + PI / 8 for hacky (not hacky it's just fast) rounding to point at player
		sprite_rotation = (rotation_rads + PI + PI / 8)
		proj_rotation = rotation_rads - PI
	else:
		# not tracking player keep everything consistent
		rotation_rads = _setup_rotation * PI / 180
		sprite_rotation = rotation_rads
		proj_rotation = rotation_rads

	if sprite_rotation >= TWO_PI:
		sprite_rotation -= TWO_PI

	# set correct frame based on rotation
	$Sprite2D.frame_coords = Vector2i(int((float(sprite_rotation) / (TWO_PI)) * 8), 0)

	# could probably use some constants here, maybe this whole (surrounding) thing could go in a function
	# but yeah we're pointing the projectile spawn marker to the player in an ellipse around the turret
	$ProjectileSpawn.position = Vector2(-cos(proj_rotation) * 91, -94 + sin(proj_rotation) * 71)

	if _oscillate:
		# calculate direction of movement and travel that way until correct distance is traveled
		# this is sloppy and inefficient
		# need to store correct direction instead of calculating it every single frame
		# or need to fix it on the oscillation axis so it can't be pushed, then just do direction inversion every time
		linear_velocity = _oscillate_dir * _oscillate_speed
		_oscillate_dir = ((_oscillate_end_pos if not _reverse_oscillation else _oscillate_start_pos) - position).normalized()
		_distance_traveled = position.distance_to(_oscillate_start_pos if not _reverse_oscillation else _oscillate_end_pos)
		if _distance_traveled >= _oscillate_dist:
			_reverse_oscillation = not _reverse_oscillation

func shoot() -> void:
	var proj = _projectile.instantiate()
	RoomManager.get_curr_room().add_child(proj)
	
	proj.global_position = $ProjectileSpawn.global_position

	# get direction to shoot projectile
	var dir
	if _track_player:
		dir = (RoomManager.get_player().global_position - $ProjectileSpawn.global_position).normalized()
	else:
		var rotation_rads = _setup_rotation * PI / 180
		dir = Vector2(-cos(rotation_rads), sin(rotation_rads))

	var lin_vel = dir * 750

	# intialize projectile w/ linear velocity
	proj.init_projectile(self, lin_vel)
