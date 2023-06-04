extends Line2D

@export var noise : FastNoiseLite 
@export var steps : float = 15
@export var snap : float = 10
@export var offset : float = 60
@export var amplitude : float = 10
@export var top_speed : float = 60
@export var multiplier : float = 3

var speed : float
var movement : Vector2 = Vector2.ZERO
var current_height : float

func _ready() -> void:
	print('ready')
	for step in range(steps):
		add_point(
			Vector2(
			step * snap,
			0
			)
		)
		print(step)

func update_points():
		
	var next_height = noise.get_noise_1d(movement.x)
	
	if get_point_position(0).x < 0:
		remove_point(0)
		add_point(Vector2(
			snap * steps,
			pow(pow(((next_height + 1.0) / 2.0) * multiplier, 2), amplitude)
		))
	var count = 0
	var min_distance = INF
	var closest_point
	for point in points:
		if point.distance_squared_to($Player.position) < min_distance:
			min_distance = point.distance_squared_to($Player.position)
			closest_point = point
		set_point_position(count, get_point_position(count) - Vector2(speed, 0))
		
			
		count += 1
	current_height = closest_point.y
	
func _physics_process(delta: float) -> void:
	speed = top_speed * delta
	update_points()
	movement.x += speed
	var player = $Player
	player.position = Vector2(75, -9 + current_height - width / 2)
