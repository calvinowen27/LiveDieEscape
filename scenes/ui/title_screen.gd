extends Node

func _on_start_button_pressed() -> void:
	EventBus.start_game.emit()
