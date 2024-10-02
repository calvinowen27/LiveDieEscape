extends Node

var _curr_scene: Node

func switch_scene_to(scene_name: String) -> Node:
	var scene_packed = load("res://scenes/%s.tscn" % scene_name)
	get_tree().change_scene_to_packed.bind(scene_packed).call_deferred()
	_curr_scene = get_tree().current_scene
	return _curr_scene

func _ready() -> void:
	pass

func _return_curr_scene() -> Node:
	return _curr_scene
