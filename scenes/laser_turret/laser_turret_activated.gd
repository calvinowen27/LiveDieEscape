extends LaserTurretState

var _target_len = 1000
var _laser_rotation = 0

@export var _seconds_per_rotation: float = 2

var _animation: Animation

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func update(delta: float) -> String:
	if not _turret.is_rotating():
		return name
	
	_laser_rotation += delta * TWO_PI / _seconds_per_rotation
	if _laser_rotation >= TWO_PI:
		_laser_rotation = 0
	
	# this whole section is bad, no constants or anything
	# idk should prob fix but it works so i'll leave it for now
	# it looks better a lil
	_laser_raycast.global_position = _turret.get_node("CenterMarker").global_position + Vector2(-cos(_laser_rotation) * 6, -sin(_laser_rotation))
	_laser_raycast.target_position = _laser_raycast.position + Vector2(-cos(_laser_rotation) * _target_len, -sin(_laser_rotation) * _target_len)
	var spark = _laser_raycast.get_node("Spark")

	# spark.position = _laser_raycast.position
	spark.global_position = _laser_raycast.global_position
	_laser_sprite.rotation = _laser_rotation

	return name

func laser_turret_state_enable(turret: LaserTurret, animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(turret, animation_player, laser_sprite, laser_raycast)
	
	_turret.set_ID_accessible(false)
	_turret.set_force_field_penetrable(false)

	_laser_sprite.visible = true
	_laser_raycast.enabled = true
	_laser_raycast.get_node("Spark").visible = true
	_laser_raycast.get_node("SparkEnd").visible = true

	_turret.get_node("LaserSfx2D").play()

	if _turret.is_rotating():
		# has to be after super cuz it gets set to 1 there
		_animation = animation_player.get_animation("laser_turret_activated_rotating")
		animation_player.speed_scale = _animation.length / _seconds_per_rotation
	
		animation_player.play("laser_turret_activated_rotating")

		_laser_rotation = 0
		_laser_raycast.position = _turret.get_node("CenterMarker").position + Vector2(-6, 0)
		_laser_raycast.target_position = _laser_raycast.position + Vector2(-_target_len, 0)
		_laser_sprite.rotation = _laser_rotation
	else:
		var rotation_rads = (_turret.get_start_rotation() % 360) * TWO_PI / 360
		_turret.get_node("Sprite2D").frame_coords = Vector2i((int)((rotation_rads / TWO_PI) * 8), 0)
	
	# print(_turret.get_node("CenterMarker").global_position)
	# print(_laser_raycast.global_position)
	# print(RoomManager.get_player().global_position)
