extends RigidBody2D

@export var rubble_count: int = 2

func _on_interactable_interact() -> void:
	self.queue_free()
