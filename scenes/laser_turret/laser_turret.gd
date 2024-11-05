extends RigidBody2D

class_name LaserTurret

func _ready() -> void:
	$ZOrdering.init($Sprite2D)
	$RayCast2D/Laser.visible = false

func reboot() -> void:
	$LaserTurretState.reboot()

func disable_turret() -> void:
	$LaserTurretState.disable_turret()

func enable_turret() -> void:
	$LaserTurretState.enable_turret()
