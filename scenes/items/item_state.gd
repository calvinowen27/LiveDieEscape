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
