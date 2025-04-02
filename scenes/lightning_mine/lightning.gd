extends Sprite2D

class_name Lightning

func _ready() -> void:
	$AnimationPlayer.play("lightning_go")

func die() -> void:
	self.queue_free()

