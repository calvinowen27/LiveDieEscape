extends RigidBody2D

const control_button_path = "res://scenes/ui/control_button.tscn"
const control_button_unavailable_text = "Room %d\nControl\nUnavailable"
const control_button_available_text = "Room %d\nControl\nAvailable"

@export var _control_rooms: Array[int]

var _level: int
var _room: int

var _control_buttons = {}

func _ready() -> void:
	# initialize interactable signals
	$Interactable.interact.connect(_on_interact)
	$Interactable.interactable_set.connect(_on_interactable_set)

	EventBus.change_room.connect(_on_room_change)
	EventBus.item_pickup.connect(_on_item_pickup)
	
	_create_control_buttons()

	_level = RoomManager.get_curr_level()
	_room = RoomManager.get_curr_room_idx()

func _create_control_buttons() -> void:
	var control_button = preload(control_button_path)
	
	for room in _control_rooms:
		var new_button = control_button.instantiate()
		_control_buttons[room] = [new_button, false, false]
		new_button.text = control_button_unavailable_text % room
		$UI/GridContainer.add_child(new_button)
		new_button.pressed.connect(_on_control_button_pressed.bind(room))

func _on_room_change(level_idx: int, room_idx: int) -> void:
	if not (level_idx == _level and room_idx == _room):
		$UI.visible = false
	
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
	$UI.visible = !$UI.visible

func _on_interactable_set(val: bool) -> void:
	if not val:
		$UI.visible = false
