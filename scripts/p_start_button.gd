extends Control

signal main_screen_request

func _process(delta: float) -> void:
	if Input.is_action_pressed('start'):
		$Sprite2D.frame = 1
		emit_signal('main_screen_request')
	else:
		$Sprite2D.frame = 0
	
