extends RigidBody2D

@export var rubble_count: int = 2

func _on_interactable_interact() -> void:
	print("now have ", Fabricator.add_resource("rubble", rubble_count), " rubble")
	self.queue_free()
