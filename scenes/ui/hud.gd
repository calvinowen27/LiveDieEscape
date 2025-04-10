extends Control

var _powerup_icons = {}

func _ready() -> void:
	EventBus.powerup_pickup.connect(_on_powerup_pickup)
	EventBus.powerup_over.connect(_on_powerup_over)

func _process(_delta: float) -> void:
	update()

# update all nodes in HUD
func update() -> void:
	update_dash_bar()
	update_room_timers()
	update_powerup_icons()

func update_dash_bar() -> void:
	var dash_timer = RoomManager.get_player().get_node("PlayerState/DashCooldownTimer")
	var dash_bar = $DashProgressBar
	dash_bar.value = dash_bar.max_value - int(dash_timer.time_left / dash_timer.wait_time * dash_bar.max_value)

func update_room_timers() -> void:
	var timer_label = $RoomTimerLabel
	var room_timers = RoomManager.get_room_timers()

	timer_label.text = ""
	for room in room_timers.keys():
		timer_label.text += "Room %d: %ds\n" % [room, room_timers[room].time_left]

func update_powerup_icons() -> void:
	for powerup_name in _powerup_icons.keys():
		var timer = PowerupManager.get_powerup_timer(powerup_name)
		var wait_time = PowerupManager.get_powerup_wait_time(powerup_name)
		if timer != null:
			_powerup_icons[powerup_name].get_node("ProgressBar").value = (timer.time_left / wait_time) * 100

func _on_powerup_pickup(powerup_name: String) -> void:
	# assume no more than 4 powerups possible to pick up at once

	if _powerup_icons.has(powerup_name): # already have icon made
		return

	# find next available icon
	for icon in $Powerups/HBoxContainer.get_children():
		if not icon.visible: # choose this one
			icon.visible = true
			_powerup_icons[powerup_name] = icon
			# set icon texture
			match powerup_name:
				"speed": (icon as TextureRect).texture = load("res://resources/art/speed_powerup.png")
			break

func _on_powerup_over(powerup_name: String) -> void:
	if not _powerup_icons.has(powerup_name): # nothing to do
		return
	
	# find icon, set invisible and remove from _powerup_icons
	var working_icon = _powerup_icons[powerup_name]
	for icon in $Powerups/HBoxContainer.get_children():
		if working_icon == icon:
			icon.visible = false
			_powerup_icons.erase(powerup_name)
			break

func get_recipe_display() -> Control:
	return %RecipeDisplay
