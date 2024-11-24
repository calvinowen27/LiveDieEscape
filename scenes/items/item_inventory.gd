extends ItemState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func item_state_enable(item: Item, sprite: Sprite2D) -> void:
	super.item_state_enable(item, sprite)

	# lock item position

	# sprite.texture = item.get_item_texture()
	sprite.visible = false
	get_node("../../ItemGlow").visible = false
