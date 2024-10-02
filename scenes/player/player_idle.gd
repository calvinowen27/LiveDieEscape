extends PlayerState

func _ready() -> void:
	super._ready()
	
	$AnimatedSprite2D.animation = "player_idle"
