extends Node

var _curr_scene: Node

func switch_scene_to(scene_name: String) -> Node:
	var prev_scene
	if _curr_scene == null:
		prev_scene = get_tree().current_scene
	else:
		prev_scene = _curr_scene

	# load and instantiate new scene, getting instance
	var scene_packed = load("res://scenes/%s.tscn" % scene_name)
	var new_scene = scene_packed.instantiate()
	get_tree().root.add_child(new_scene)
	
	# reassign _curr_scene, free old scenes
	_curr_scene = new_scene
	prev_scene.queue_free()
	return _curr_scene

func toggle_game_paused() -> bool:
	if not Game.is_player_dead():
		get_tree().paused = !get_tree().paused
	
	return get_tree().paused

func _ready() -> void:
	pass

func get_curr_scene() -> Node:
	return _curr_scene
