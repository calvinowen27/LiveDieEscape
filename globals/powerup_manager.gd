extends Node

var _powerups = {} # key is powerup name (string), value is array of form [timer, timer wait time]

func add_powerup(powerup_name: String) -> void:
	var timer: SceneTreeTimer

	var wait_time

	match powerup_name:
		"speed":
			wait_time = 5
			StatManager.change_stat("speed_mult", 2)
	
	timer = get_tree().create_timer(wait_time)
	timer.timeout.connect(remove_powerup.bind(powerup_name))

	_powerups[powerup_name] = [timer, wait_time]

	EventBus.powerup_pickup.emit(powerup_name)

func remove_powerup(powerup_name: String) -> void:
	match powerup_name:
		"speed":
			StatManager.revert_stat_change("speed_mult", 2)
	
	# only remove entry if timer is over (dupes)
	if _powerups[powerup_name][0].time_left == 0:
		_powerups.erase(powerup_name)
		EventBus.powerup_over.emit(powerup_name)

func get_powerup_timer(powerup_name: String) -> SceneTreeTimer:
	if not _powerups.has(powerup_name):
		return null
	
	return _powerups[powerup_name][0]

func get_powerup_wait_time(powerup_name: String) -> float:
	if not _powerups.has(powerup_name):
		return -1
	
	return _powerups[powerup_name][1]
