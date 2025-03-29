extends RigidBody2D

@export var _control_room: int

func _on_interactable_interact() -> void:
	RoomManager.bridge_acid(_control_room)

	$Sprite2D.frame = 1 # switch to flipped sprite

	$Interactable.set_active(false)
