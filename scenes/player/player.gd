extends RigidBody2D

func _ready() -> void:
	$ZOrdering.init($Sprite2D)

func die() -> void:
	RoomManager.reset_level(0)
