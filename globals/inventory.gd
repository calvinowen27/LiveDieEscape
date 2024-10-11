extends Node

var _slots = []
var _size = 4

func _ready() -> void:
	for i in range(_size):
		_slots.append(null)

func add_item(item: Item) -> int:
	var item_idx = -1
	for i in range(_size):
		if _slots[i] == null:
			_slots[i] = item
			item_idx = i
			break
	
	# add item to hud
	if item_idx != -1:
		EventBus.item_pickup.emit(item, item_idx)
	
	return item_idx

func drop_item(item_idx: int) -> void:
	if _slots[item_idx] == null:
		print_debug("drop_item(): no item in slot %d" % item_idx)
		return
	
	# remove item from hud
	if item_idx >= 0 and item_idx < _slots.size():
		_slots[item_idx] = null

func del_item(item: Item) -> void:
	if item not in _slots:
		return
	
	EventBus.item_drop.emit(_slots.find(item, 0))
	item.queue_free()

func get_items_of_group(item_group: String) -> Array:
	var result = []
	
	for slot_item in _slots:
		var item = slot_item
		if item != null and item.is_in_group(item_group):
			result.append(item)
	
	return result

func clear() -> void:
	for i in range(_size):
		var item = _slots[i]
		if item != null:
			EventBus.item_drop.emit(i)
			item.queue_free()
			_slots[i] = null

func size() -> int:
	return _size
