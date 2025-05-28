extends Sprite2D

class_name Lightning

var _body: Node2D

func _ready() -> void:
	$AnimationPlayer.play("lightning_go")

func init(body: Node2D) -> void:
	_body = body

func die() -> void:
	self.queue_free()

func get_body() -> Node2D:
	return _body

func on_player() -> bool:
	return _body == RoomManager.get_player()

