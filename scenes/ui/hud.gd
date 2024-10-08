extends Control

func _ready() -> void:
	EventBus.item_pickup.connect(_on_item_pickup)
	EventBus.item_drop.connect(_on_item_drop)

	# init inventory slots with reference to hud and respective slot nums
	var slots = get_tree().get_nodes_in_group("InventorySlots")

	for i in range(slots.size()):
		slots[i].init(self, i)

func _process(_delta: float) -> void:
	update()

# update all nodes in HUD
func update() -> void:
	$StatsLabel.text = ""
	var stats = StatManager.get_stats()
	for stat in stats:
		$StatsLabel.text += "%s: %d\n" % [stat, stats[stat]]

func _on_item_pickup(item: Item, idx: int) -> void:
	var inventory_slots = get_tree().get_nodes_in_group("InventorySlots")
	var slot = inventory_slots[idx]

	# change item parent to slot
	RoomManager.get_curr_room().remove_child.bind(item).call_deferred()
	slot.add_child.bind(item).call_deferred()

	slot.set_item(item)
	item.pickup()

func _on_item_drop(item_idx: int) -> void:
	var inventory_slots = get_tree().get_nodes_in_group("InventorySlots")
	var slot = inventory_slots[item_idx]
	var item = slot.get_item()
	if item == null:
		return

	# change item parent to raoom
	slot.remove_child.bind(item).call_deferred()
	RoomManager.get_curr_room().add_child.bind(item).call_deferred()

	slot.clear_item()
	item.drop()
