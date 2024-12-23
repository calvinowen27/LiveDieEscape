extends Area2D

@export var _temporary: bool = true

func _on_timer_timeout() -> void:
	if _temporary:
		self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	# basically if it's a projectile kill it (can't do this through the projectile rigidbody for some reason)
	if (body as Projectile) != null:
		body.queue_free()
