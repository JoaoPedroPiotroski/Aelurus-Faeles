extends TextureRect

@export var icon : Texture2D
@export var fighter : Fighter

func _start(_icon, _fighter):
	icon = _icon
	texture = icon
	fighter = _fighter

func _process(delta):
	pass
