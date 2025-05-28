extends TextureRect

class_name LaserTurretControl

var _laser_turret: LaserTurret
var _control_point: ControlPoint

var _is_usable: bool = false
var _is_enabled: bool = true

@onready var _button: Button = $Button

# @export var _button_not_usable_color: Color
@export var _button_turret_enabled_color: Color
@export var _button_turret_disabled_color: Color
@export var _button_hover_offset_color: Color

func _ready() -> void:
	_button.disabled = true
	_set_button_color(_button_turret_enabled_color)

func init(laser_turret: LaserTurret, control_point: ControlPoint) -> void:
	_laser_turret = laser_turret
	_control_point = control_point
	var control_room = _control_point.get_room()

	# TODO: constantsa
	position = (laser_turret.global_position / max(control_room.get_width(), control_room.get_height())) * 1080

func _on_button_pressed() -> void:
	if !_is_usable: return

	_is_enabled = _laser_turret.toggle()

	if _is_enabled:
		_set_button_color(_button_turret_enabled_color)
	else:
		_set_button_color(_button_turret_disabled_color)

func _set_button_color(color: Color) -> void:
	var normal_stylebox = _button.get_theme_stylebox("normal").duplicate()
	normal_stylebox.bg_color = color
	_button.add_theme_stylebox_override("normal", normal_stylebox)
	
	# average hover offset color with current color (just a bit grayed out)
	var hover_stylebox = _button.get_theme_stylebox("hover").duplicate()
	hover_stylebox.bg_color = (color + _button_hover_offset_color) / 2
	_button.add_theme_stylebox_override("hover", hover_stylebox)

func obtained_id() -> void:
	_is_usable = true
	_button.disabled = false

func has_id(id: int) -> bool:
	return id == _laser_turret.get_id()

func is_usable() -> bool:
	return _is_usable
