class_name Player
extends AllyFighter

var facing_direction : Vector2 = Vector2.RIGHT
var is_on_ground : bool = false

@onready var camera: Camera2D = $Camera2D
@onready var sprite_2d = $Sprite2D

func are_signs_equal(v1 : float, v2: float) -> bool:
	if v1 >= 0 and v2 >= 0:
		return true
	if v1 < 0 and v2 < 0:
		return true
	return false
