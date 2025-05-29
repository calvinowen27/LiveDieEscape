extends Node2D

class_name MaterialGet

var _fab_material: FabricateMaterial

func init(fab_material: FabricateMaterial, quantity: int, start_pos: Vector2 = Vector2.ZERO) -> void:
	_fab_material = fab_material

	$MaterialParticle.texture = _fab_material.get_texture()
	$QuantityParticle.texture.region = Rect2i(quantity * 16, 0, 16, 16) # each digit is 16x16 in spritesheet

	position = start_pos
	
	visible = false

func start() -> void:
	$MaterialParticle.emitting = true
	$QuantityParticle.emitting = true
	visible = true

# kill on end
func _on_material_particle_finished() -> void:
	self.queue_free()
