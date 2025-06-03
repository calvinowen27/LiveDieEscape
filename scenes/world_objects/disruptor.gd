extends WorldObject

class_name Disruptor

var _disrupting: Array[Disruptable]

func _ready() -> void:
	super._ready()

	set_range(_data["range"])

func set_range(range_: float) -> void:
	var col_shape = $DetectionArea/CollisionShape2D
	col_shape.scale.x = range_
	col_shape.scale.y = range_

func die() -> void:
	# stop disrupting everything and then destroy self
	for disruptable in _disrupting:
		disruptable.end_disrupt(self)
	
	super.die()

# start disrupting anything in range
func _on_detection_area_body_entered(body: Node2D) -> void:
	if not body.has_node("Disruptable"): return

	var disruptable = body.get_node("Disruptable")

	# only if not already disrupting
	if disruptable in _disrupting: return

	disruptable.disrupt(self)
	_disrupting.append(disruptable)

# stop disrupting if out of range
func _on_detection_area_body_exited(body: Node2D) -> void:
	if not body.has_node("Disruptable"): return

	var disruptable = body.get_node("Disruptable")

	# only if currently disrupting
	if disruptable not in _disrupting: return

	disruptable.end_disrupt(self)
	_disrupting.erase(disruptable)
