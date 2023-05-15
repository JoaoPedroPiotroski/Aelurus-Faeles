extends Control

func _process(delta: float) -> void:
	if Input.is_action_pressed('select'):
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0
