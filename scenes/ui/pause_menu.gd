extends Panel

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		SceneManager.toggle_game_paused()
		visible = !visible

func _on_resume_button_pressed() -> void:
	SceneManager.toggle_game_paused()
	visible = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
