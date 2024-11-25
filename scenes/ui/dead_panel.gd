extends Panel

func _ready() -> void:
	visible = false
	EventBus.player_death.connect(_on_player_death)

func _on_player_death() -> void:
	visible = true
	get_tree().paused = true

func _on_respawn_button_pressed() -> void:
	get_tree().paused = false
	EventBus.player_respawn.emit()
	visible = false
