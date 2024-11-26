extends LaserTurretState

var _target_len = 1000
var _laser_rotation = 0

func _ready() -> void:
	pass

func update(_delta: float) -> String:
	_laser_rotation += _delta
	if _laser_rotation >= 2 * PI:
		_laser_rotation = 0
	
	_laser_raycast.target_position = Vector2(-cos(_laser_rotation) * _target_len, -sin(_laser_rotation) * _target_len)

	_laser_sprite.rotation = _laser_rotation

	return name

func laser_turret_state_enable(animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(animation_player, laser_sprite, laser_raycast)
	
	animation_player.play("laser_turret_activated_rotating")
	laser_sprite.visible = true
	laser_raycast.enabled = true
