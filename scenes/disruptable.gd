extends Node

class_name Disruptable

signal disruption(disruptor: Disruptor)
signal end_disruption(disruptor: Disruptor)

var _body: Node2D

func _ready() -> void:
	_body = get_parent()

func disrupt(disruptor: Disruptor) -> void:
	disruption.emit(disruptor)

func end_disrupt(disruptor: Disruptor) -> void:
	end_disruption.emit(disruptor)