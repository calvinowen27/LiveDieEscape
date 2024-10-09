extends ItemState

var _can_be_picked_up = true

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func item_state_enable(item: Item, sprite: Sprite2D) -> void:
	super.item_state_enable(item, sprite)

	# unlock item position
	
	# start item pickup timer
	_can_be_picked_up = false
	$PickupTimer.start()

	sprite.texture = item.get_item_texture()
	sprite.visible = true

func _on_pickup_timer_timeout() -> void:
	_can_be_picked_up = true

func can_be_picked_up() -> bool:
	return _can_be_picked_up
