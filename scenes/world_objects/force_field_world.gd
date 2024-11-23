extends Area2D

@export var _temporary: bool = true

func _on_timer_timeout() -> void:
	if _temporary:
		self.queue_free()
