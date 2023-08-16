#@tool
extends Line2D

# cada ponto tem 20 pixels de distancia H
# cada curva tem 200 pixels de comprimento
# tem 20 * 9999 pixels ( 199980 ) como pontuação máxima
# tem 200000 / 200 ( 1000 ) curvas 

@export var amount_of_curves : float = 1000
@export var points_per_curve : int = 10
@export var h_pixels_per_point : int = 10
@export var max_height : float = 60
@export var min_height : float = -60

@export var noise : FastNoiseLite 
@export var test_curve : Curve

var collision_shapes : Array = []


func _ready():
	pass


	
func update_line():
	clear_points()
	var last_curve_end = 0
	var x_pos = 0
	for c in amount_of_curves:
		var curve = Curve.new()
		curve.bake_resolution = points_per_curve
		curve.max_value = max_height# * noise.get_noise_1d(-c * 10)
		curve.min_value = min_height
		curve.add_point(Vector2(0, last_curve_end), 0, 0)
		curve.add_point(Vector2(1, max_height * noise.get_noise_1d(-c * 10)), 0, 0)
		last_curve_end = curve.sample(1)
		for p in range(points_per_curve):
			#print('c: ', c)
			#print('p: ', p)
			add_point(Vector2(
				x_pos,
				curve.sample_baked(p / float(points_per_curve))
				
			))
			print(p/float(points_per_curve))
			print(curve.sample_baked(p / float(points_per_curve)))
			x_pos += h_pixels_per_point
			#print(get_point_position(get_point_count()-1))
	
func find_closest_point(seek_global_position : Vector2):
	var seek_position = to_local(seek_global_position)
	var smallest_distance = INF
	var distance_changed = false
	for point in range(get_point_count()):
		if get_point_position(point).distance_squared_to(seek_position) > smallest_distance and distance_changed:
			return get_point_position(point)
		if get_point_position(point).distance_squared_to(seek_position) < smallest_distance:
			smallest_distance = get_point_position(point).distance_squared_to(seek_position)
			distance_changed = true
	
func on_player_position_updated(player_global_position : Vector2):
	var player_position = to_local(player_global_position)
	var queued_for_removal = []
	for point in get_point_count():
		if (player_position - get_point_position(point)).x < 60:
			#remove_point(point)
			break
		else:
			break

func _on_visibility_changed() -> void:
	if visible:
		update_line()

