extends RigidBody2D

const _projectile = preload("res://scenes/sentry_turret/projectile.tscn")

@export var _track_player: bool = true
@export var _setup_rotation: int = 0

func _ready() -> void:
	$Sprite2D.frame_coords = Vector2i(int((float(_setup_rotation) / 360) * 4), 0)

	var rotation_rads = _setup_rotation * PI / 180
	$ProjectileSpawn.position = Vector2(-cos(rotation_rads) * 135, -81 + sin(rotation_rads) * 115)
	print($ProjectileSpawn.position)

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	var proj = _projectile.instantiate()
	RoomManager.get_curr_room().add_child(proj)
	
	proj.global_position = $ProjectileSpawn.global_position

	var dir
	if _track_player:
		dir = (RoomManager.get_player().global_position - $ProjectileSpawn.global_position).normalized()
	else:
		var rotation_rads = _setup_rotation * PI / 180
		dir = Vector2(-cos(rotation_rads), sin(rotation_rads))

	var lin_vel = dir * 500

	proj.init_projectile(self, lin_vel)
