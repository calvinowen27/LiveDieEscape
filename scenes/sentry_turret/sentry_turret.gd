extends RigidBody2D

const _projectile = preload("res://scenes/sentry_turret/projectile.tscn")
const TWO_PI = 2*PI

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
	$Sprite2D.frame_coords = Vector2i(int((float(_setup_rotation) / 360) * 8), 0)

	var rotation_rads = _setup_rotation * PI / 180
	$ProjectileSpawn.position = Vector2(-cos(rotation_rads) * 111, -81 + sin(rotation_rads) * 118)

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
		sprite_rotation = (rotation_rads + PI + PI / 8)
		proj_rotation = rotation_rads - PI
	else:
		rotation_rads = _setup_rotation * PI / 180
		sprite_rotation = rotation_rads
		proj_rotation = rotation_rads

	if sprite_rotation >= TWO_PI:
		sprite_rotation -= TWO_PI

	$Sprite2D.frame_coords = Vector2i(int((float(sprite_rotation) / (TWO_PI)) * 8), 0)
	$ProjectileSpawn.position = Vector2(-cos(proj_rotation) * 91, -94 + sin(proj_rotation) * 71)

	if _oscillate:
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
