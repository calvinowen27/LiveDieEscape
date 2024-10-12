extends RigidBody2D

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	
	# initialize interactable signals
	$Interactable.interact.connect(_on_interact)
	$Interactable.interactable_set.connect(_on_interactable_set)

func _on_interact() -> void:
	$UI.visible = !$UI.visible

func _on_interactable_set(val: bool) -> void:
	if not val:
		$UI.visible = false
