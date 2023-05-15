extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_pressed('ui_copy'):
		animation_player.play("left")
	elif Input.is_action_pressed('sel'):
		animation_player.play("down")
	elif Input.is_action_pressed('act'):
		animation_player.play("right")
	elif Input.is_action_pressed('ui_copy'):
		animation_player.play("up")
	else:
		animation_player.play("none")
