class_name RacingCar
extends CharacterBody2D

var wheel_base = 5
var acceleration = Vector2.ZERO
var engine_power =  100
var steering_angle = 15
var friction = -0.9
var drag = -0.001
var race_started = false

@export_node_path('RaceCheckpoint') var finish_line

@onready var current_checkpoint : RaceCheckpoint = get_node(finish_line)

func _physics_process(delta: float) -> void:
	if not race_started:
		return
	var dir = 0
	acceleration = Vector2.ZERO
	if Input.is_action_pressed('left'):
		dir -= 1
	if Input.is_action_pressed('right'):
		dir += 1
	var steer_dir = dir * steering_angle
	if Input.is_action_pressed('sel'):
		acceleration = transform.x * engine_power
		
	#friction
	if velocity.length() < 0.05:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction
	var drag_force = velocity * velocity.length() * drag
	acceleration += drag_force + friction_force
	
	#steering
	
	var rear_wheel = position - transform.x * wheel_base/2.0
	var front_wheel = position + transform.x * wheel_base/2.0
	rear_wheel += velocity*delta
	front_wheel += velocity.rotated(deg_to_rad(steer_dir)) * delta
	var new_heading = (front_wheel-rear_wheel).normalized()
	velocity = new_heading * velocity.length()
	if velocity != Vector2.ZERO:
		rotation = velocity.angle()
	velocity += acceleration * delta
	$Camera2D.global_rotation = deg_to_rad(90) + Vector2(global_rotation, global_rotation).snapped(Vector2(deg_to_rad(90), deg_to_rad(90))).x
	move_and_slide()
