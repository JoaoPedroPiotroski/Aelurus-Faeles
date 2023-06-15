extends Sprite2D

@export_node_path("Line2D") var world_line
@export var gravity : float = 8
@export var angle_friction_influence : float = 1

var velocity : Vector2 = Vector2.ZERO
var snapped_to_line = true
var line_snap_cd = 0.3
var last_frame_on_line = false
var surface_normal = Vector2.ZERO

signal update_player_position(Vector2)

func _ready() -> void:
	world_line = get_node(world_line)
	
func _draw() -> void:
	#draw_line(Vector2.ZERO, velocity, Color.BLUE, 4)
	draw_line(Vector2.ZERO, surface_normal * 15, Color.PURPLE, 2)

func _physics_process(delta: float) -> void:
	emit_signal('update_player_position', global_position)
	var friction : float = 0.8
	line_snap_cd -= delta
	if line_snap_cd < 0:
		snapped_to_line = true
		
	if Input.is_action_just_pressed("act"):
		print('act')
		snapped_to_line = false
		line_snap_cd = 0.3
		velocity.y = -20
	
	velocity.y += gravity * delta
	
	if last_frame_on_line:
		surface_normal = - ((
			get_normal(world_line.find_closest_point(global_position), world_line.find_closest_point(global_position + Vector2(2, 0))).normalized()
		+	get_normal(world_line.find_closest_point(global_position), world_line.find_closest_point(global_position + Vector2(1, 0))).normalized()
		+	get_normal(world_line.find_closest_point(global_position), world_line.find_closest_point(global_position + Vector2(3, 0))).normalized()
			)/3)
		rotation = lerp(rotation, surface_normal.x, 0.25)
	print(rotation)
	#print(surface_normal)
	if world_line.find_closest_point(global_position).y < world_line.find_closest_point(global_position + Vector2(1, 0)).y:
		if abs( world_line.find_closest_point(global_position).y - world_line.find_closest_point(global_position + Vector2(1, 0)).y ) > 0.1:
			friction = 0.8 - abs(world_line.find_closest_point(global_position).angle_to(world_line.find_closest_point(global_position + Vector2(1, 0)))) * angle_friction_influence
	elif world_line.find_closest_point(global_position).y > world_line.find_closest_point(global_position + Vector2(1, 0)).y:
		if abs( world_line.find_closest_point(global_position).y - world_line.find_closest_point(global_position + Vector2(1, 0)).y ) > 0.1:
			friction = 0.8 - abs(world_line.find_closest_point(global_position).angle_to(world_line.find_closest_point(global_position + Vector2(1, 0)))) * angle_friction_influence
	velocity.x += 20
	velocity.x = min(50, velocity.x)
	#velocity.x *= friction * delta
	#print(friction)
	
	global_position += velocity * delta
	
	var world_line_position = world_line.find_closest_point(global_position)
	if last_frame_on_line and snapped_to_line:
		global_position.y = world_line_position.y - 6
		velocity.y = 0
	if global_position.y >= world_line_position.y - 6:
		snapped_to_line = true
		global_position.y = world_line_position.y - 6
		last_frame_on_line = true
	else:
		last_frame_on_line = false
	queue_redraw()

func get_normal(vec1 : Vector2, vec2 : Vector2):
	var dx = vec2.x - vec1.x
	var dy = vec2.y - vec1.y
	return Vector2(-dy, dx)
