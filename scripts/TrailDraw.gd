extends Node2D

@export var trailmaker : TrailMaker
@export var ground_clr : Color = Color.RED
@export var normal_clr : Color = Color.WHITE

func _draw():
	for point in trailmaker.trail:
		if point.standable:
			draw_circle(to_local(point.position), 3, ground_clr)
		else:
			draw_circle(to_local(point.position), 3, normal_clr)
			
func _physics_process(delta):
	queue_redraw()
