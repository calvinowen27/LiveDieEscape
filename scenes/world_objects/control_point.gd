extends RigidBody2D

@export var _rooms: Array[int]

var _control_buttons: Array

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	
	# initialize interactable signals
	$Interactable.interact.connect(_on_interact)
	$Interactable.interactable_set.connect(_on_interactable_set)
	
	var control_button = preload("res://scenes/ui/control_button.tscn")
	
	for room in _rooms:
		var new_button = control_button.instantiate()
		_control_buttons.append(new_button)
		new_button.text = "Room %d\n------------\nControl\nUnavailable" % room
		$UI/GridContainer.add_child(new_button)

func _on_interact() -> void:
	$UI.visible = !$UI.visible

func _on_interactable_set(val: bool) -> void:
	if not val:
		$UI.visible = false
