extends Behavior

class_name PlayerBehavior

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func enable() -> void:
	super.enable()
	
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play()

func disable() -> void:
	super.disable()
	
	$AnimatedSprite2D.visible = false
	$AnimatedSprite2D.stop()
