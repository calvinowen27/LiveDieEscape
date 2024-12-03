extends Node

func add_powerup(powerup_name: String) -> void:
	var timer: SceneTreeTimer

	match powerup_name:
		"speed":
			timer = get_tree().create_timer(5)
			StatManager.change_stat("speed_mult", 2)
	
	timer.timeout.connect(remove_powerup.bind(powerup_name))

func remove_powerup(powerup_name: String) -> void:
	match powerup_name:
		"speed":
			StatManager.revert_stat_change("speed_mult", 2)
