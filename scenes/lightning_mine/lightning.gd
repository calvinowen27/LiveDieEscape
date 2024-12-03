extends Sprite2D

func _ready() -> void:
	$AnimationPlayer.play("lightning_go")

func die() -> void:
	self.queue_free()

