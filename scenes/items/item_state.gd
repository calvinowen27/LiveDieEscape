extends State

class_name ItemState

var _item: Item
var _rigidbody: RigidBody2D
var _sprite: Sprite2D

func _ready() -> void:
	_set_curr_state("ItemGround")

func _set_curr_state(new_state_name: String) -> State:
	var new_state = super._set_curr_state(new_state_name)
	
	# _curr_state == new_state at this point
	
	if new_state == null:
		return null
	
	# enable new state
	if _curr_state != null:
		var item = get_parent()
		var rigidbody = get_parent()
		var sprite = rigidbody.get_node("Sprite2D")
		_curr_state.item_state_enable(item, rigidbody, sprite)

	return new_state

func item_state_enable(item: Item, rigidbody: RigidBody2D, sprite: Sprite2D) -> void:
	_item = item
	_rigidbody = rigidbody
	_sprite = sprite

	super.enable()

func _on_item_body_entered(body: Node) -> void:
	if body == RoomManager.get_player() and _curr_state.name == "ItemGround":
		var item = get_parent()
		Inventory.add_item(item)
