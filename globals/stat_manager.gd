extends Node

var _base_stats = {
			"speed": 2
			}

var _stats = {}

var _powerups = {}

var _powerup_icon_path = "res://resources/art/"

func _ready() -> void:
	reset_stats()

# add stat: val to _stats, returns false if stat already in _base_stats
# returns true if successful
func add_base_stat(stat: String, val: int) -> bool:
	if stat in _base_stats.keys():
		print_debug("add_stat(): Stat %s already exists in _base_stats" % stat)
		return false
	
	_base_stats[stat] = val
	
	return true

# set value of stat to val, returns false if stat doesn't exist,
# returns true otherwise (success)
func set_base_stat(stat: String, val: int) -> bool:
	if stat not in _base_stats.keys():
		print_debug("set_stat(): Stat %s doesn't exist in _base_stats" % stat)
		return false
	
	_base_stats[stat] = val
	
	return true

# get value of stat to val, returns -1 if stat doesn't exist
func get_stat(stat: String) -> int:
	if stat not in _stats.keys():
		print_debug("get_stat(): Stat %s doesn't exist in _stats" % stat)
		return -1
	
	return _stats[stat]

# get value of stat to val, returns -1 if stat doesn't exist
func get_base_stat(stat: String) -> int:
	if stat not in _base_stats.keys():
		print_debug("get_base_stat(): Stat %s doesn't exist in _base_stats" % stat)
		return -1
	
	return _base_stats[stat]

# change stat by dval, returns false on failure, true on success
func change_stat(stat: String, dval: int) -> bool:
	if stat not in _stats.keys():
		print_debug("change_stat(): Stat %s doesn't exist in _stats" % stat)
		return false
	
	_stats[stat] += dval
	
	return true

# change base stat by dval, returns false on failure, true on success
func change_base_stat(stat: String, dval: int) -> bool:
	if stat not in _base_stats.keys():
		print_debug("change_stat(): Stat %s doesn't exist in _base_stats" % stat)
		return false
	
	_base_stats[stat] += dval
	
	return true

# reset stats to base
func reset_stats() -> void:
	for stat in _base_stats.keys():
		_stats[stat] = _base_stats[stat]

func get_stats() -> Dictionary:
	return _stats

func get_base_stats() -> Dictionary:
	return _base_stats

func add_powerup(powerup_name: String, duration: int) -> void:
	_powerups[powerup_name] = get_tree().create_timer(duration)

	if powerup_name == "speed":
		set_base_stat("speed", 15)
		# change_stat("speed", 13)

	var texture_rects = get_tree().root.get_node("Main/HUDRect/HUD/Powerups/HBoxContainer").get_children()

	var chosen_rect
	var icon = load("%s%s_powerup.png" % [_powerup_icon_path, powerup_name])

	for rect in texture_rects:
		if not rect.visible or rect.texture == icon:
			chosen_rect = rect
			rect.texture = icon
			rect.visible = true
			break

	await _powerups[powerup_name].timeout

	if powerup_name == "speed":
		# change_stat("speed", get_base_stat("speed") - get_stat("speed"))
		set_base_stat("speed", 2)

	chosen_rect.visible = false

	_powerups.erase(powerup_name)

func get_powerups() -> Dictionary:
	return _powerups
