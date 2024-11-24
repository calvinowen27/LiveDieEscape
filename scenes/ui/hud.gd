extends Control

func _ready() -> void:
	EventBus.item_pickup.connect(_on_item_pickup)
	EventBus.item_drop.connect(_on_item_drop)
	EventBus.item_use.connect(_on_item_use)

	# init inventory slots with reference to hud and respective slot nums
	var slots = get_tree().get_nodes_in_group("InventorySlots")

	for i in range(slots.size()):
		slots[i].init(self, i)

func _process(_delta: float) -> void:
	update()

# update all nodes in HUD
func update() -> void:
	var dash_timer = RoomManager.get_player().get_node("PlayerState/DashCooldownTimer")
	var dash_bar = $DashProgressBar
	dash_bar.value = dash_bar.max_value - int(dash_timer.time_left / dash_timer.wait_time * dash_bar.max_value)

	var timer_label = $RoomTimerLabel
	var room_timers = RoomManager.get_room_timers()

	timer_label.text = ""
	for room in room_timers.keys():
		timer_label.text += "Room %d: %ds\n" % [room, room_timers[room].time_left]
	
	

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
	
	Inventory.drop_item(item_idx)

	# change item parent to raoom
	slot.remove_child.bind(item).call_deferred()
	RoomManager.get_curr_room().add_child.bind(item).call_deferred()

	slot.clear_item()
	item.drop()

func _on_item_use(item_idx: int) -> void:
	var inventory_slots = get_tree().get_nodes_in_group("InventorySlots")
	var slot = inventory_slots[item_idx]
	var item = slot.get_item()
	if item == null:
		return
	
	item.use()
