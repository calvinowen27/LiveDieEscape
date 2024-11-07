extends Node

var _items: Array[Sprite2D]

var _sprite: Sprite2D

func _ready() -> void:
	for child in get_children():
		_items.append(child as Sprite2D)

	_sprite = get_parent()

	EventBus.item_pickup.connect(_on_item_pickup)
	EventBus.item_drop.connect(_on_item_drop)

func _process(_delta: float) -> void:
	for item in _items:
		item.z_index = _sprite.z_index + 1

func _on_item_pickup(item: Item, idx: int) -> void:
	_items[idx].texture = item.get_item_texture()
	_items[idx].visible = true

func _on_item_drop(item_idx: int) -> void:
	_items[item_idx].visible = false
