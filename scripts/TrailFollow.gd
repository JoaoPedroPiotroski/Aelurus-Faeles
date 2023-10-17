class_name TrailFollower
extends Component

@export_node_path("CharacterBody2D") var trail_follower_np : NodePath
@export_node_path("Node") var trailmaker_np : NodePath
var acceleration = 20
var max_speed = 100
var friction = 0.98
var gravity = 8
var jump_force = 180
var grace_time : float = 0
var trailmaker : TrailMaker
var follower : CharacterBody2D

@export var require_ground : bool = true
@export var min_distance : float = 32
var current_point : TrailMaker.TrailPoint
var current_standable_point : TrailMaker.TrailPoint

func _ready():
	trailmaker = get_node(trailmaker_np)
	follower = get_node(trail_follower_np)
	
func find_next_standable_point(p_point : TrailMaker.TrailPoint) -> TrailMaker.TrailPoint:
	var found_current = false
	for point in trailmaker.trail:
		if found_current and point.standable:
			return point
		if point == p_point:
			found_current = true
	return current_standable_point
	
func is_last_standable_point(p_point : TrailMaker.TrailPoint) -> bool:
	var is_last = true
	var found_current = false
	for point in trailmaker.trail:
		if found_current and point.standable:
			return false
		if point == p_point:
			found_current = true
	
	return is_last
	
func is_last_distant_point(p_point : TrailMaker.TrailPoint) -> bool:
	var is_last = true
	var found_current = false
	for point in trailmaker.trail:
		if found_current and point.standable and point.position.distance_to(
			trailmaker.last_tpoint.position
		) < min_distance:
			return false
		if point == p_point:
			found_current = true
	
	return is_last

func find_next_point(p_point : TrailMaker.TrailPoint) -> TrailMaker.TrailPoint:
	var found_current = false
	for point in trailmaker.trail:
		if found_current:
			return point
		if point == p_point:
			found_current = true
	return current_point

func is_before_current_standable(p_point : TrailMaker.TrailPoint) -> bool:
	var is_before = false
	var found_current = false
	var found_point = false
	for point in trailmaker.trail:
		if point == p_point and not found_current:
			return true
		if point == current_standable_point:
			found_current = true
	
	return is_before
	
func find_next_rest_spot(p_point : TrailMaker.TrailPoint) -> TrailMaker.TrailPoint:
	var next_rest = p_point
	var found_current = false
	for point in trailmaker.trail:
		if found_current:
			if point.standable:
				if point.position.distance_to(trailmaker.trailmaker.global_position) > min_distance:
					return point
		if point == p_point:
			found_current = true
		
	return next_rest
	
func is_there_far_enough_standable_point() -> bool:
	for point in trailmaker.trail:
		if (point.standable or not require_ground) and point.position.distance_to(trailmaker.trailmaker.global_position) > min_distance and point != current_point:
			return true
	return false

func is_there_grounded_point() -> bool:
	return false

func _process(delta):
	grace_time -= delta
	follower.velocity.y += gravity * delta
	
	follower.move_and_slide()
	#print(trailmaker.trail)
	# WHILE NOT START WORKING 
	# DO THIS 
	if not current_point:
		if trailmaker.trail.size() == 0:
			return
		else:
			current_point = trailmaker.trail[0]
	if not current_standable_point:
		if trailmaker.trail.size() == 0:
			return
		else:
			if find_next_standable_point(current_point):
				current_standable_point = find_next_standable_point(current_point)
			else:
				return

	var next_point = find_next_point(current_point)
	#* int(not is_last_standable_point(current_standable_point) ) * int(not is_last_distant_point(current_standable_point))
	
	if is_there_far_enough_standable_point():
		if grace_time < 0:
			follower.global_position = current_point.position
			current_point = null
			grace_time = 3
			return
		if current_point.position.distance_to(follower.global_position) < max_speed /10:
			current_point = find_next_point(current_point)
			grace_time = 3
			trailmaker.trail.pop_front()
	else:
		follower.velocity = Vector2.ZERO
		
	var move_direction := follower.global_position.direction_to(current_point.position)
	if not current_point.position.distance_to(follower.global_position) < max_speed /10:
		follower.velocity += acceleration * move_direction
		follower.velocity.x *= friction
		follower.velocity.x = clamp(follower.velocity.x, -max_speed, max_speed)
		
		if is_zero_approx(move_direction.x):
			follower.velocity.x *= 0.8
#	if current_point.position.y < follower.global_position.y - 5:
#		follower.velocity.y = jump_force  * follower.global_position.direction_to(current_point.position).y
	if follower.global_position.distance_to(current_point.position) > 25:
		print("Dist: ", follower.global_position.distance_to(current_point.position))
		follower.global_position = current_point.position 
	#follower.velocity =  current_point.velocity
	
	




