extends Line2D

@export var _valid_color: Color
@export var _invalid_color: Color

var _endpoint: Vector2

func _ready() -> void:
	default_color = _valid_color

func _update() -> void:
	if _endpoint.length() > Fabricator.get_fabricate_range():
		default_color = _invalid_color
	else:
		default_color = _valid_color

func set_endpoint(endpoint: Vector2) -> void:
	_endpoint = endpoint

	points[1] = _endpoint

	_update()
