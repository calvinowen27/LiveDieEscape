extends ItemState

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
func item_state_enable(item: Item, rigidbody: RigidBody2D, sprite: Sprite2D) -> void:
	super.item_state_enable(item, rigidbody, sprite)

	rigidbody.sleeping = false

	sprite.texture = item.get_item_texture()
