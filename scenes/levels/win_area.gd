extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body == RoomManager.get_player():
		SceneManager.switch_scene_to("ui/win")
