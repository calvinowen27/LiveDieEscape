extends RigidBody2D

func _ready() -> void:
	$ZOrdering.init($Sprite2D)

func die() -> void:
	EventBus.level_reset.emit(0)
	Inventory.clear()
