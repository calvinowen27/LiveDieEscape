extends Panel

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update()

# update all nodes in HUD
func update() -> void:
	$StatsLabel.text = ""
	var stats = StatManager.get_stats()
	for stat in stats:
		$StatsLabel.text += "%s: %d\n" % [stat, stats[stat]]
