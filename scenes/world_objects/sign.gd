extends Sprite2D

@export_multiline var _sign_text: Array[String]

func _ready() -> void:
	$Interactable/InteractLabel.rotation = -rotation

func _on_interactable_interact() -> void:
	var text_box = get_tree().root.get_node("Main/TextBox")
	text_box.get_node("Label").text = _sign_text[0]
	text_box.visible = !text_box.visible

func _on_interact_area_body_exited(body:Node2D) -> void:
	if body == RoomManager.get_player():
		var text_box = get_tree().root.get_node("Main/TextBox")
		text_box.get_node("Label").text = ""
		text_box.visible = false
