extends Sprite2D

var animations = [
	"full_circle",
	"rotate1",
	"rotate2",
	"rotate3"
]

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print('mudando animaçao')
	animations.shuffle()
	$AnimationPlayer.play(animations[0])
