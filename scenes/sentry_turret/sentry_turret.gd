extends RigidBody2D

var _projectile = preload("res://scenes/sentry_turret/projectile.tscn")

func _on_shoot_cooldown_timer_timeout() -> void:
	shoot()

func shoot() -> void:
	var proj = _projectile.instantiate()
	RoomManager.get_curr_room().add_child(proj)
	
	proj.global_position = $ProjectileSpawn.global_position

	var lin_vel = (RoomManager.get_player().global_position - $ProjectileSpawn.global_position).normalized() * 500

	proj.init_projectile(self, lin_vel)
