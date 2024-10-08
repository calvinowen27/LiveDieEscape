extends Control

func _ready() -> void:
	EventBus.item_pickup.connect(_on_item_pickup)
	EventBus.item_drop.connect(_on_item_drop)

func _process(delta: float) -> void:
	update()

# update all nodes in HUD
func update() -> void:
	$StatsLabel.text = ""
	var stats = StatManager.get_stats()
	for stat in stats:
		$StatsLabel.text += "%s: %d\n" % [stat, stats[stat]]

func _on_item_pickup(item: Item, idx: int) -> void:
	pass

func _on_item_drop(item_idx: int) -> void:
	pass
