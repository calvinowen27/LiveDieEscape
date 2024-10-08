extends Node2D

class_name Item

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func pickup() -> void:
	$ItemState._set_curr_state("ItemInventory")

func drop() -> void:
	$ItemState._set_curr_state("ItemGround")

func use() -> void:
	$ItemState._set_curr_state("ItemPlaced")
