extends Area2D

func _ready() -> void:
	$AnimationPlayer.play("acid")

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player():
		body.die()
