extends Node

func _on_start_button_pressed() -> void:
	EventBus.start_game.emit()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
