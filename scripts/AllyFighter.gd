class_name AllyFighter
extends Fighter

const TILE_SIZE = 8

@export_group("Visuals")
@export var sprite_flip := true
@export var unsquash_delta := 10.0

@export_group("Physics")
@export var acceleration : float = .05
@export var decceleration : float = .1
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

var ledge_timer : float = -1.0
var flip_timer : float = -1.0

var sprite : Sprite2D
var move_direction := Vector2.ZERO :
	set(value):
		if value.x != 0:
			if sign(value.x) != sign(look_direction.x):
				flip_timer = 0.2
			look_direction.x = value.x
		if value.y != 0:
			look_direction.y = value.y
		move_direction = value
var look_direction := Vector2.RIGHT

var last_target_point : TrailMaker.TrailPoint
var nav_path : Array
var nav_agent : NavigationAgent2D

func _ready():
	super()
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
	if name == "Player":
		print("Move_Dir = ", move_direction)
		print(velocity)
	animate(delta)
	match(CONTROL_STATE):
		CONTROL_STATES.PLAYER:
			_player_controlled(delta)
		CONTROL_STATES.AI:
			_ai_controlled(delta)

func tick_timers(delta):
	ledge_timer -= delta
	flip_timer -= delta

func get_user_input():
	move_direction = Input.get_vector("left", "right", "up", "down")

func move(delta):
	var target_speed : Vector2 = move_direction * max_speed
	var speed_difference : Vector2 = target_speed - velocity
	var accel_rate : float = acceleration if (abs(target_speed.length()) > 0.01) else decceleration
	var movement : Vector2 = Vector2(
		pow(abs(speed_difference.x) * accel_rate, 2) * sign(speed_difference.x),
		pow(abs(speed_difference.y) * accel_rate, 2) * sign(speed_difference.y)
	)
	#pow(abs(speed_difference.length()) * accel_rate, 2) * sign(speed_difference.length())
	if name == "Player":
		print("Vel antes: ", velocity)
	velocity += movement# * TILE_SIZE
	if name == "Player":
		print("Vel depois: ", velocity)
	velocity = velocity.limit_length(max_speed)
	if move_direction.is_zero_approx():
		print("zerando")
		velocity *= 0.8
	if velocity.is_zero_approx():
		velocity = Vector2.ZERO
	if move_direction.x != 0:
		look_direction.x = move_direction.x
	if move_direction.y != 0:
		look_direction.y = move_direction.y

func animate(delta) -> void:
	if sprite_flip:
		sprite.flip_h = look_direction.x < 0
		if flip_timer > 0:
			sprite.scale.x = lerp(scale.x, 0., min(flip_timer * 5., 1.))
		else:
			sprite.scale.x = lerp(scale.x, 1., 2 * delta)

func _player_controlled(delta):
	get_user_input()

	queue_redraw()
	
	move(delta)
	
	move_and_slide()

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
	var target_point : TrailMaker.TrailPoint = find_last_valid_point()
	if target_point:
		nav_agent.target_position = target_point.position
		if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
			var next_point = nav_agent.get_next_path_position()
			next_point += randf() * Vector2(2, 2)
			move_direction = global_position.direction_to(next_point)
			move(delta)
			if (global_position.distance_to(target_point.position) < min_standing_distance):
				velocity.x = 0
		if global_position.distance_to(target_point.position) > max_acceptable_distance:
			global_position = target_point.position
	move_and_slide()
	
