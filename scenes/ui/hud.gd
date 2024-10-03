extends Panel

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

# update all nodes in HUD
func update() -> void:
	$StatsLabel.text = ""
	#for stat in StatManager.get_stats():
