extends Node

var _items = []

func add_item(item: Item) -> void:
	if item not in _items:
		_items.append(item)

func contains_item(item: Item) -> bool:
	return item in _items

func get_items_of_group(group: String) -> Array:
	#print("getting items in group ", group)
	var res = []
	for item in _items:
		item.is_in_group(group)
		res.append(item)
	
	#print("\t ", res)
	return res

func del_item(item: Item) -> void:
	if item not in _items:
		return
	
	_items.erase(item)
	item.queue_free()

func clear() -> void:
	for item in _items:
		item.queue_free()
	
	_items.clear()
