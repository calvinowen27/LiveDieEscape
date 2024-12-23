extends RigidBody2D

const _projectile = preload("res://scenes/sentry_turret/projectile.tscn")
const TWO_PI = 2*PI

@export var _track_player: bool = true
@export var _setup_rotation: int = 0

func _ready() -> void:
	$Sprite2D.frame_coords = Vector2i(int((float(_setup_rotation) / 360) * 8), 0)

	var rotation_rads = _setup_rotation * PI / 180
	$ProjectileSpawn.position = Vector2(-cos(rotation_rads) * 111, -81 + sin(rotation_rads) * 118)

	$ZOrdering.init($Sprite2D)

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot()

func _process(_delta: float) -> void:
	var rot_dir = (RoomManager.get_player().global_position - global_position).normalized()
	var rotation_rads = atan2(-rot_dir.y, rot_dir.x)

	var sprite_rotation = (rotation_rads + PI + PI / 8)
	if sprite_rotation >= TWO_PI:
		sprite_rotation -= TWO_PI
	
	var proj_rotation = rotation_rads - PI

	$Sprite2D.frame_coords = Vector2i(int((float(sprite_rotation) / (TWO_PI)) * 8), 0)
	$ProjectileSpawn.position = Vector2(-cos(proj_rotation) * 91, -94 + sin(proj_rotation) * 71)

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
