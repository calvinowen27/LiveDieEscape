extends Node

var _slots = []
var _size = 4

func _ready() -> void:
	for i in range(_size):
		_slots.append(null)

func add_item(item: Item) -> bool:
	var item_added = false
	for i in range(_size):
		if _slots[i] == null:
			_slots[i] = item
			item_added = true
	
	return item_added

func size() -> int:
	return _size
