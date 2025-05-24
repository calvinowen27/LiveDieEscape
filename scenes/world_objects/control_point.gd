extends RigidBody2D

class_name ControlPoint

@export var _control_rooms: Array[int]
@export var _control_room: int

@export var _laser_turret_control: PackedScene

var _level: int
var _room: int

var _control_buttons: Array[LaserTurretControl] = []

@onready var _ui: Control = %UI
@onready var _interactable: Node2D = $Interactable

func _ready() -> void:
	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()

	EventBus.learn_security_id.connect(_on_security_id_learned)

func init() -> void:
	_create_control_buttons()

func _create_control_buttons() -> void:
	var control_room = RoomManager.get_room(_level, _control_room)

	if control_room != null:
		var laser_turrets = control_room.get_laser_turrets()
		# var a = false
		for turret in laser_turrets:
			var new_control = _laser_turret_control.instantiate()
			_control_buttons.append(new_control)
			new_control.init(turret, self)
			_ui.add_child(new_control)
			# TEMP:
			# if !a:
			# 	new_control.obtained_id()
			# 	a = true

func get_level_idx() -> int:
	return _level

func get_room_idx() -> int:
	return _room

func get_room() -> Room:
	return RoomManager.get_room(_level, _room)

func _on_interactable_interact() -> void:
	_ui.visible = !_ui.visible
	_interactable.set_active(true)

func _on_interactable_interactable_set(val:bool) -> void:
	if not val:
		_ui.visible = false

func _on_security_id_learned(id: int) -> void:
	for button in _control_buttons:
		if button.has_id(id):
			button.obtained_id()
