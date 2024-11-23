extends ItemState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func item_state_enable(item: Item, sprite: Sprite2D) -> void:
	super.item_state_enable(item, sprite)

	var obj = preload("res://scenes/world_objects/force_field_world.tscn").instantiate()
	RoomManager.get_curr_room().add_child(obj)
	obj.position = RoomManager.get_player().position - Vector2(0, 35)

	Inventory.del_item(get_node("../../") as Item)

