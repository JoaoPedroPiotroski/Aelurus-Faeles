class_name AllyFighter
extends Fighter

const TILE_SIZE = 8

@export_group("Visuals")
@export var sprite_flip := true
@export var sine_squash := false
@export var sine_squash_mult := 4.0
@export var unsquash_delta := 10.0
var sine_squash_forwards = true

@export_group("Physics")
@export var acceleration : float = .05
@export var decceleration : float = .1
@export var max_speed : float = 80

@export_group("World")
enum CONTROL_STATES {
	PLAYER,
	AI,
	BATTLE
}
@export var CONTROL_STATE : CONTROL_STATES = CONTROL_STATES.AI

@export_group("AI")
@export var trailmaker : TrailMaker
@export var min_standing_distance : float = 16
@export var max_acceptable_distance : float = 150

@onready var stats_display = preload("res://scenes/AllyFighterDisplay.tscn")

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
var battle_target_pos := Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			battle_target_pos = get_global_mouse_position()

func _ready():
	if CONTROL_STATE == CONTROL_STATES.PLAYER:
		Global.player = self
		Global.party.append(self)
	elif CONTROL_STATE == CONTROL_STATES.AI:
		Global.party.append(self)
	super()
	nav_agent = NavigationAgent2D.new()
	if has_node("Sprite2D"):
		sprite = get_node("Sprite2D")
	
	add_child(nav_agent)
	nav_agent.debug_enabled = true 
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
		CONTROL_STATES.BATTLE:
			_battle_controlled(delta)

func tick_timers(delta):
	ledge_timer -= delta
	flip_timer -= delta

func get_user_input():
	if Global.in_battle:
		return 
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
	velocity += movement# * TILE_SIZE
	velocity = velocity.limit_length(max_speed)
	if move_direction.is_zero_approx():
		velocity *= 0.8
	if velocity.is_zero_approx():
		velocity = Vector2.ZERO
	if move_direction.x != 0:
		look_direction.x = move_direction.x
	if move_direction.y != 0:
		look_direction.y = move_direction.y

func animate(delta) -> void:
	if sine_squash and move_direction != Vector2.ZERO:
		if sine_squash_forwards: 
			sprite.scale.y = lerp(sprite.scale.y, 0.7, delta  * sine_squash_mult)
		else:
			sprite.scale.y = lerp(sprite.scale.y, 1.3, delta  * sine_squash_mult)
		if sprite.scale.y > 1.1 or sprite.scale.y < 0.9:
			sine_squash_forwards = !sine_squash_forwards
	if sprite_flip:
		sprite.flip_h = look_direction.x < 0
		if flip_timer > 0:
			sprite.scale.x = lerp(scale.x, 0., min(flip_timer * 5., 1.))
		else:
			sprite.scale.x = lerp(scale.x, 1., 2 * delta)

func _battle_controlled(delta):
	nav_agent.target_position = battle_target_pos
	if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
		var next_point = nav_agent.get_next_path_position()
		move_direction = global_position.direction_to(next_point)
		move(delta)
		if (global_position.distance_to(battle_target_pos) < min_standing_distance):
			velocity = Vector2.ZERO
			global_position = lerp(global_position, battle_target_pos, 1.0 * delta )
	move_and_slide()

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
	
func prepare_for_battle():
	var display = stats_display.instantiate()
	add_child(display)
	if has_node("StatsPosition"):
		display.position = get_node("StatsPosition").position
	display.governor = self
	battle_target_pos = global_position
	CONTROL_STATE = CONTROL_STATES.BATTLE
	
	
func is_point_valid(p_point : TrailMaker.TrailPoint) -> bool:
	var r_value = false
	if p_point.position.distance_to(trailmaker.trailmaker.global_position) > min_standing_distance:
		r_value = true
	return r_value

func _ai_controlled(delta):
	var target_point : TrailMaker.TrailPoint = find_last_valid_point()
	if target_point:
		nav_agent.target_position = target_point.position
		if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
			var next_point = nav_agent.get_next_path_position()
			#next_point += randf() * Vector2(2, 2)
			move_direction = global_position.direction_to(next_point)
			move(delta)
			if (global_position.distance_to(target_point.position) < min_standing_distance):
				velocity = Vector2.ZERO
				move_direction = Vector2.ZERO
		if global_position.distance_to(target_point.position) > max_acceptable_distance:
			global_position = target_point.position
	move_and_slide()
	
