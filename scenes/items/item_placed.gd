extends ItemState

@export var _object_name: String
@export var _pos_offset: Vector2

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func item_state_enable(item: Item, sprite: Sprite2D) -> void:
	super.item_state_enable(item, sprite)

	RoomManager.spawn_object(_object_name, RoomManager.get_player().position + _pos_offset)

	Inventory.del_item(get_node("../../") as Item)
