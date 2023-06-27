class_name Player
extends Entity

var acceleration = 4
var max_speed = 80
var friction = 0.98
var gravity = 8
var jump_force = 180

var jump_timer : float = 0
var shader_position : Vector2
var shader_velocity : Vector2

@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite
func take_input(delta : float):
	jump_timer -= delta
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if Input.is_action_just_pressed("sel"):
		jump_timer = 0.2

func _physics_process(delta: float) -> void:
	take_input(delta)
	
	# Global shader thing
	shader_position = lerp(shader_position, global_position, 0.2 + pow(velocity.length()/ 80, 2.))
	shader_velocity = lerp(shader_velocity, velocity, 0.2 + pow(velocity.length()/ 80, 2.))
	RenderingServer.global_shader_parameter_set('player_position', shader_position)
	RenderingServer.global_shader_parameter_set('player_velocity', shader_velocity)

	#prototype animation thing
	if velocity.x != 0:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play('walk')
		sprite.flip_h = velocity.x < 0
	else:
		$AnimationPlayer.stop()
	
	# Camera stuff
	camera.drag_vertical_enabled = !is_on_floor()
	if is_equal_approx(abs(velocity.x), max_speed):
		camera.offset.x = lerp(camera.offset.x, move_direction.x * (max_speed), 0.5 * delta)
	else:
		camera.offset.x = lerp(camera.offset.x, 0.0, 1 * delta)
	if not are_signs_equal(camera.offset.x, move_direction.x):
		camera.offset.x = lerp(camera.offset.x, move_direction.x * (max_speed), delta)
	camera.drag_horizontal_enabled = abs(velocity.x) < max_speed / 2.
	
	#movement
	velocity += acceleration * move_direction
	velocity.x *= friction
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if is_zero_approx(move_direction.x):
		velocity.x *= 0.8
	velocity.y += gravity
	if jump_timer > 0 and is_on_floor():
		velocity.y = - jump_force
	if Input.is_action_just_released("sel"):
		if velocity.y < 0:
			velocity.y *= 0.2
	
	move_and_slide()

func are_signs_equal(v1 : float, v2: float) -> bool:
	if v1 > 0 and v2 > 0:
		return true
	if v1 < 0 and v2 < 0:
		return true
	return false
