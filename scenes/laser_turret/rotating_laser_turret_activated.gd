extends LaserTurretState

var _target_len = 1000
var _laser_rotation = 0

@export var _seconds_per_rotation: float = 2

var _animation: Animation

func update(_delta: float) -> String:
	_laser_rotation += _delta * TWO_PI / _seconds_per_rotation
	if _laser_rotation >= TWO_PI:
		_laser_rotation = 0
	
	# this whole section is bad, no constants or anything
	# idk should prob fix but it works so i'll leave it for now
	# it looks better a lil
	_laser_raycast.position = _turret.get_node("CenterMarker").position + Vector2(-cos(_laser_rotation) * 27, 0)
	_laser_raycast.target_position = _laser_raycast.position + Vector2(-cos(_laser_rotation) * _target_len, -sin(_laser_rotation) * _target_len)
	var spark = _turret.get_node("Sprite2D/Spark")

	# spark.position = _laser_raycast.position
	spark.global_position = _laser_raycast.global_position

	if _laser_raycast.get_node("Laser/ZOrderingMarker").global_position.y > _turret.global_position.y:
		_laser_sprite.z_index = 4096
		spark.z_index = 0
	else:
		_laser_sprite.z_index = 0
		spark.z_index = -1

	_laser_sprite.rotation = _laser_rotation

	return name

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	# has to be after super cuz it gets set to 1 there
	_animation = animation_player.get_animation("rotating_laser_turret_activated")
	animation_player.speed_scale = _animation.length / _seconds_per_rotation

	_turret.get_node("Sprite2D/Spark").visible = true
	animation_player.play("rotating_laser_turret_activated")

	_laser_rotation = 0
	_laser_raycast.position = _turret.get_node("CenterMarker").position + Vector2(-27, 0)
	_laser_raycast.target_position = _laser_raycast.position + Vector2(-_target_len, 0)
	_laser_sprite.rotation = _laser_rotation

	laser_sprite.visible = true
	laser_raycast.enabled = true
