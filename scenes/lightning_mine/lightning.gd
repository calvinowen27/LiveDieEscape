extends Sprite2D

func _ready() -> void:
	$AnimationPlayer.play("lightning_go")

func die() -> void:
	self.queue_free()

func _on_alive_timer_timeout() -> void:
	StatManager.set_base_stat("speed", 7)

	die()

