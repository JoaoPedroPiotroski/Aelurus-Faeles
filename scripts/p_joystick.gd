extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_pressed('left'):
		animation_player.play("left")
	elif Input.is_action_pressed('down'):
		animation_player.play("down")
	elif Input.is_action_pressed('right'):
		animation_player.play("right")
	elif Input.is_action_pressed('up'):
		animation_player.play("up")
	else:
		animation_player.play("none")
