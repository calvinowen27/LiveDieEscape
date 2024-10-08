extends State

class_name ItemState

var _rigidbody: RigidBody2D
var _sprite: Sprite2D

func _ready() -> void:
	_set_curr_state("ItemGround")

func item_state_enable(rigidbody: RigidBody2D, sprite: Sprite2D) -> void:
	_rigidbody = rigidbody
	_sprite = sprite

	super.enable()

func _on_item_body_entered(body: Node) -> void:
	if body == RoomManager.get_player() and _curr_state.name == "ItemGround":
		var item = get_parent()
		Inventory.add_item(item)
