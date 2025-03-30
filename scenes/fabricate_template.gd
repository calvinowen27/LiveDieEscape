extends Area2D

var valid: bool = true

var invalid_objs: Array

func _on_body_entered(body: Node2D) -> void:
	if body as RigidBody2D != null:
		valid = false
		invalid_objs.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body in invalid_objs:
		invalid_objs.erase(body)
		if invalid_objs.size() == 0:
			valid = true
