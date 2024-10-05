extends LaserTurretState

var primed = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func laser_turret_state_enable(animated_sprite: AnimatedSprite2D) -> void:
	super.laser_turret_state_enable(animated_sprite)
	
	animated_sprite.animation = "laser_turret_priming"
	animated_sprite.play()
	primed = false
	$PrimeTimer.start()

func update(delta: float) -> String:
	if primed:
		return "LaserTurretActivated"
	
	return name

func _on_prime_timer_timeout() -> void:
	primed = true
