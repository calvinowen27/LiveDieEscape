extends RigidBody2D

class_name Disruptor

var _disrupting: Array[Disruptable]

func die() -> void:
	for disruptable in _disrupting:
		disruptable.end_disrupt(self)
	
	self.queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.has_node("Disruptable"):
		var disruptable = body.get_node("Disruptable")
		if disruptable in _disrupting: return

		disruptable.disrupt(self)
		_disrupting.append(disruptable)

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.has_node("Disruptable"):
		var disruptable = body.get_node("Disruptable")
		if disruptable not in _disrupting: return

		disruptable.end_disrupt(self)
		_disrupting.erase(disruptable)
