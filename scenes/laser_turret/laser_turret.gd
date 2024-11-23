extends RigidBody2D

class_name LaserTurret

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

	$Interactable.set_active(false)

func reboot() -> void:
	$LaserTurretState.reboot()

func disable_turret() -> void:
	$LaserTurretState.disable_turret()

	$Interactable.set_active(true)

func enable_turret() -> void:
	$LaserTurretState.enable_turret()

	$Interactable.set_active(false)

func _on_interactable_interact() -> void:
	var ff = $ForceFieldWorld
	remove_child(ff)
	ff.queue_free()

	RoomManager.instantiate_item("force_field_item", position + Vector2(0, 15))

