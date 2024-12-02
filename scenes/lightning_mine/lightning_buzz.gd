extends LightningState

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func lightning_state_enable(animation_player: AnimationPlayer, sprite: Sprite2D) -> void:
	super.lightning_state_enable(animation_player, sprite)
	
	animation_player.play("lightning_buzz")

	StatManager.set_base_stat("speed", 0)
