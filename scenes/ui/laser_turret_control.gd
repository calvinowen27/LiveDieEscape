extends TextureRect

class_name LaserTurretControl

var _laser_turret: LaserTurret
var _control_point: ControlPoint

var _is_usable: bool = false
var _is_enabled: bool = true

func _ready() -> void:
	$Button.disabled = true

func init(laser_turret: LaserTurret, control_point: ControlPoint) -> void:
	_laser_turret = laser_turret
	_control_point = control_point
	var control_room = _control_point.get_room()

	position = (laser_turret.global_position / max(control_room.get_width(), control_room.get_height())) * 1080

func _on_button_pressed() -> void:
	if !_is_usable: return

	_is_enabled = !_is_enabled
	_laser_turret.toggle()

	if _is_enabled:
		var stylebox = $Button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color(0, 1, 0, 0.5)
		$Button.add_theme_stylebox_override("normal", stylebox)
	else:
		var stylebox = $Button.get_theme_stylebox("normal").duplicate()
		stylebox.bg_color = Color(1, 0, 0, 0.5)
		$Button.add_theme_stylebox_override("normal", stylebox)

func obtained_id() -> void:
	_is_usable = true
	$Button.disabled = false

func is_usable() -> bool:
	return _is_usable
