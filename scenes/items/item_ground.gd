extends ItemState

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func item_state_enable(rigidbody: RigidBody2D, sprite: Sprite2D) -> void:
	super.item_state_enable(rigidbody, sprite)

	rigidbody.sleeping = false
