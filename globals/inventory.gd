extends Node

var _items = []

func add_item(item: Item) -> void:
	if item not in _items:
		_items.append(item)

func contains_item(item: Item) -> bool:
	return item in _items

func get_items_of_group(group: String) -> Array:
	var res = []
	for item in _items:
		if item.is_in_group(group):
			res.append(item)
	
	return res

func del_item(item: Item) -> void:
	if item not in _items:
		return
	
	_items.erase(item)
	item.queue_free()

func clear() -> void:
	for i in range(_items.size()):
		if _items[i]:
			_items[i].queue_free()
		
		_items[i] = null
	
	_items.clear()
