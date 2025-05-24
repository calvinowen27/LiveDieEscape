extends RigidBody2D

const control_button_path = "res://scenes/ui/control_button.tscn"
const control_button_unavailable_text = "Room %d\nControl\nUnavailable"
const control_button_available_text = "Room %d\nControl\nAvailable"

@export var _control_rooms: Array[int]
@export var _control_room: int

@export var _laser_turret_control: PackedScene

var _level: int
var _room: int

var _control_buttons = {}

@onready var _ui: Control = %UI
@onready var _interactable: Node2D = $Interactable

func _ready() -> void:
	# initialize interactable signals
	_interactable.interact.connect(_on_interact)
	_interactable.interactable_set.connect(_on_interactable_set)

	EventBus.change_room.connect(_on_room_change)
	EventBus.item_pickup.connect(_on_item_pickup)
	
	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()

	_create_control_buttons()


func _create_control_buttons() -> void:
	var control_room = RoomManager.get_room(_level, _control_room)

	if control_room != null:
		var laser_turrets = control_room.get_node("%LaserTurrets").get_children()
		for turret in laser_turrets:
			var new_control = _laser_turret_control.instantiate()
			_ui.add_child(new_control)
			new_control.position = (turret.global_position / max(control_room.get_width(), control_room.get_height())) * 1080

func _on_room_change(level_idx: int, room_idx: int) -> void:
	if not (level_idx == _level and room_idx == _room):
		_ui.visible = false
	
	_update_control()

func _on_item_pickup(_item: Item) -> void:
	_update_control()

func _update_control() -> void:
	var control_chips = Inventory.get_items_of_group("ControlChips")

	# updating control permissions for each room associated with this control point
	# based on player inventory

	# look at each control room, and check for corresponding control chip in inventory
	for control_room in _control_rooms:
		var control_available = false

		var button_info = _control_buttons[control_room]
		if button_info == null or button_info[2]:
			continue
		
		# set control to available by default
		var button = button_info[0]
		button.text = control_button_available_text % control_room
		button_info[1] = true
		button.set("theme_override_colors/font_color", Color(0.0, 1.0, 0.0, 1.0))
		button.set("theme_override_colors/font_pressed_color", Color(0.0, 1.0, 0.0, 1.0))
		button.set("theme_override_colors/font_hover_pressed_color", Color(0.0, 1.0, 0.0, 1.0))

		for chip in control_chips:
			if chip.get_control_level() != _level:
				continue
			
			# control is available, update permissions
			if chip.get_control_room() == control_room:
				control_available = true
				break
		
		# no control available, so set graphics and update permissions
		if not control_available:
			button_info[1] = false
			button.text = control_button_unavailable_text % control_room
			button.set("theme_override_colors/font_color", Color(1.0, 0.0, 0.0, 1.0))
			button.set("theme_override_colors/font_pressed_color", Color(1.0, 0.0, 0.0, 1.0))
			button.set("theme_override_colors/font_hover_pressed_color", Color(1.0, 0.0, 0.0, 1.0))

func _on_control_button_pressed(room_idx: int) -> void:
	var button_info = _control_buttons[room_idx]
	if button_info[1]:
		var control_chips = Inventory.get_items_of_group("ControlChips")

		if not button_info[2]:
			for chip in control_chips:
				if chip.get_control_level() != _level:
					continue
				
				# control is available, update permissions
				if chip.get_control_room() == room_idx:
					button_info[2] = true
					Inventory.del_item(chip)
					break

		RoomManager.reboot_room(_level, room_idx)

func _on_interact() -> void:
	_ui.visible = !_ui.visible
	_interactable.set_active(true)

func _on_interactable_set(val: bool) -> void:
	if not val:
		_ui.visible = false
