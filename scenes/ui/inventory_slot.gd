extends Panel

var _item: Item
var _is_filled = false

func set_item(item: Item) -> void:
	_is_filled = true

	# set sprite
	var sprite = $Sprite2D
	sprite.texture = item.get_item_texture()
	sprite.visible = true

func clear_item() -> void:
	_is_filled = false

	# clear sprite
	var sprite = $Sprite2D
	sprite.texture = null
	sprite.visible = false

func get_item() -> Item:
	return _item

func is_filled() -> bool:
	return _is_filled
