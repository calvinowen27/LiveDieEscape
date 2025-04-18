extends Panel

var _hud: Control
var _slot_idx: int

var _item: Item
var _is_filled = false

var _mouse_over = false

func init(hud: Control, slot_idx: int):
	_hud = hud
	_slot_idx = slot_idx

func _process(_delta: float) -> void:
	if _mouse_over and Input.is_action_just_pressed("drop_item"):
		EventBus.item_drop.emit(_slot_idx)
	
	if _mouse_over and Input.is_action_just_pressed("use_item"):
		EventBus.item_use.emit(_slot_idx)

func set_item(item: Item) -> void:
	_is_filled = true
	
	_item = item

	# set item label to item name
	$ItemLabel.text = _item.get_item_name()

	# set info label to item info
	$InfoLabel.text = _item.get_item_info()
	$InfoLabel.visible = false

	# set sprite
	var sprite = $Sprite2D
	sprite.texture = item.get_item_texture()
	sprite.visible = true

func clear_item() -> void:
	_is_filled = false

	# clear labels
	$ItemLabel.text = ""
	$InfoLabel.text = ""
	$InfoLabel.visible = false

	# clear sprite
	var sprite = $Sprite2D
	sprite.texture = null
	sprite.visible = false

func get_item() -> Item:
	return _item

func is_filled() -> bool:
	return _is_filled

func _on_mouse_entered() -> void:
	_mouse_over = true

	if _item != null:
		$InfoLabel.visible = true

func _on_mouse_exited() -> void:
	_mouse_over = false

	$InfoLabel.visible = false

func get_slot_idx() -> int:
	return _slot_idx
