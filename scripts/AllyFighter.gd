class_name AllyFighter
extends Fighter

const TILE_SIZE = 8

@export_node_path("GridMap") var path : NodePath

@export_group("Visuals")
@export var sprite_flip := true
@export var unsquash_delta := 10.0
@export var do_jump_squash := true
@export var jump_squash := Vector2(0.7, 1.5)

@export_group("Physics")
@export var max_falling_speed : float = 16. ## in tiles/sec
@export var jump_height : float ## in tiles
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float
@export var jump_hang_velocity : float = 0.
@export var jump_hang_gravity_mul : float = 1.
@export var acceleration : float = 2.
@export var decceleration : float = 16.
@export var max_speed : float = 80

@export_group("World")
enum CONTROL_STATES {
	PLAYER,
	AI
}
@export var CONTROL_STATE : CONTROL_STATES = CONTROL_STATES.AI

@export_group("AI")
@export var trailmaker : TrailMaker
@export var min_standing_distance : float = 14
@export var max_acceptable_distance : float = 150

var jump_timer : float = -1.0
var ledge_timer : float = -1.0
var flip_timer : float = -1.0

var jump_velocity : float 
var jump_gravity : float = 5.0
var fall_gravity : float = 5.0
var sprite : Sprite2D
var move_direction := 0.0 :
	set(value):
		if sign(value) != sign(move_direction):
			flip_timer = 0.2
		move_direction = value
var look_direction := Vector2.RIGHT

var last_target_point : TrailMaker.TrailPoint
var nav_path : Array
var nav_agent : NavigationAgent2D

func _ready():
	super()
	update_jump_vars(jump_height)
	nav_agent = NavigationAgent2D.new()
	if has_node("Sprite2D"):
		sprite = get_node("Sprite2D")
	
	add_child(nav_agent)
	nav_agent.debug_enabled = false 
	nav_agent.path_postprocessing = NavigationPathQueryParameters2D.PATH_POSTPROCESSING_EDGECENTERED

func _process(delta):
	sprite.scale = lerp(sprite.scale, Vector2(1, 1), pow(unsquash_delta * delta, 2))
	tick_timers(delta)

func _physics_process(delta):
	animate(delta)
	match(CONTROL_STATE):
		CONTROL_STATES.PLAYER:
			_player_controlled(delta)
		CONTROL_STATES.AI:
			_ai_controlled(delta)

func apply_physics(delta):
	velocity.y += get_gravity() * delta

func tick_timers(delta):
	jump_timer -= delta
	ledge_timer -= delta
	flip_timer -= delta

func get_gravity() -> float:
	var grav := jump_gravity if velocity.y < 0. else fall_gravity
	
	if abs(velocity.y) < jump_hang_velocity:
		grav *= jump_hang_gravity_mul
	
	return grav

func get_user_input():
	move_direction = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if Input.is_action_just_pressed("sel"):
		jump_timer = 0.2

func update_jump_vars(p_height : float):
	jump_velocity = ((2. * p_height * TILE_SIZE) / jump_time_to_peak) * - 1.
	jump_gravity = ((-2. * p_height * TILE_SIZE) / (jump_time_to_peak * jump_time_to_peak)) * - 1.
	fall_gravity = ((-2. * p_height * TILE_SIZE) / (jump_time_to_descent * jump_time_to_descent)) * - 1.

func move_horizontal(delta):
	var target_speed : float = move_direction * max_speed
	var speed_difference : float = target_speed - velocity.x
	var accel_rate : float = acceleration if (abs(target_speed) > 0.01) else decceleration
	var movement : float = pow(abs(speed_difference) * accel_rate, 2) * sign(speed_difference)
	velocity.x += movement * TILE_SIZE
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if is_zero_approx(move_direction):
		velocity.x *= 0.8
	if is_zero_approx(velocity.x):
		velocity.x = 0
	if move_direction != 0:
		look_direction.x = move_direction

func jump(p_height : float):
	if do_jump_squash:
		sprite.scale = jump_squash
	update_jump_vars(p_height)
	velocity.y = jump_velocity

func animate(delta) -> void:
	if sprite_flip and sprite and is_on_floor():
		sprite.flip_h = look_direction.x < 0
		if flip_timer > 0:
			sprite.scale.x = lerp(scale.x, 0., min(flip_timer * 5., 1.))
		else:
			sprite.scale.x = lerp(scale.x, 1., 2 * delta)

func _player_controlled(delta):
	pass

func find_last_valid_point() -> TrailMaker.TrailPoint:
	var r_point : TrailMaker.TrailPoint
	if not trailmaker:
		return r_point
	
	for i in range(trailmaker.trail.size() - 1, 0, -1):
		if is_point_valid(trailmaker.trail[i]):
			return trailmaker.trail[i]
	return r_point
	
func is_point_valid(p_point : TrailMaker.TrailPoint) -> bool:
	var r_value = false
	if p_point.standable and p_point.position.distance_to(trailmaker.trailmaker.global_position) > min_standing_distance:
		r_value = true
	return r_value

func _ai_controlled(delta):
	apply_physics(delta)
	velocity.y = min(velocity.y, max_falling_speed * TILE_SIZE)
	var target_point : TrailMaker.TrailPoint = find_last_valid_point()
	if target_point:
		nav_agent.target_position = target_point.position
		if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
			var next_point = nav_agent.get_next_path_position()
			next_point += randf() * Vector2(2, 2)
			move_direction = int(next_point.x > global_position.x) - int(next_point.x < global_position.x) 
			move_horizontal(delta)
			if (global_position.distance_to(target_point.position) < min_standing_distance):
				velocity.x = 0
			
			if is_on_floor() and next_point.y - global_position.y < -4:
				jump(jump_height)
		if global_position.distance_to(target_point.position) > max_acceptable_distance:
			global_position = target_point.position
	move_and_slide()
	
