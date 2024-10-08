extends Panel

var _item: Item
var _is_filled = false

func set_item(item: Item) -> void:
	_is_filled = true

func clear_item(item: Item) -> void:
	_is_filled = false

func get_item() -> Item:
	return _item

func is_filled() -> bool:
	return _is_filled
