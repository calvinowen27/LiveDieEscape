extends Area2D

@export var _temporary: bool = true

func _on_timer_timeout() -> void:
	if _temporary:
		self.queue_free()


func _on_body_entered(body: Node2D) -> void:
	if (body as Projectile) != null:
		body.queue_free()
