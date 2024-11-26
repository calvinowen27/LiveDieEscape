extends LaserTurretState

const TWO_PI: float = 2 * PI

var _target_len = 1000
var _laser_rotation = 0

@export var _seconds_per_rotation: float = 2

var _animation: Animation

var _init_pos: Vector2

func _ready() -> void:
	pass

func update(_delta: float) -> String:
	_laser_rotation += _delta * TWO_PI / _seconds_per_rotation
	if _laser_rotation >= TWO_PI:
		_laser_rotation = 0
	
	var dist = (_laser_raycast.position - get_node("../../ForceFieldWorld").position).length()
	_laser_raycast.position = get_node("../../ForceFieldWorld").position + Vector2(-cos(_laser_rotation) * dist, -sin(_laser_rotation) * dist * 2 / 3)
	_laser_raycast.target_position = _laser_raycast.position + Vector2(-cos(_laser_rotation) * _target_len, -sin(_laser_rotation) * _target_len)

	_laser_sprite.rotation = _laser_rotation

	return name

func laser_turret_state_enable(animation_player: AnimationPlayer, laser_sprite: Sprite2D, laser_raycast: RayCast2D) -> void:
	super.laser_turret_state_enable(animation_player, laser_sprite, laser_raycast)
	
	_animation = animation_player.get_animation("laser_turret_activated_rotating")
	animation_player.play("laser_turret_activated_rotating")
	animation_player.speed_scale = _animation.length / _seconds_per_rotation

	_init_pos = _laser_raycast.position

	laser_sprite.visible = true
	laser_raycast.enabled = true
