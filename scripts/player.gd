class_name Player
extends AllyFighter

var jump_timer : float = 0
var move_direction : Vector2 = Vector2.ZERO
var facing_direction : Vector2 = Vector2.RIGHT
var is_on_ground : bool = false

@onready var camera: Camera2D = $Camera2D

func take_input(delta : float):
	jump_timer -= delta
	move_direction = Vector2.ZERO
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if move_direction.x != 0:
		facing_direction = move_direction
	
	if Input.is_action_just_pressed("sel"):
		jump_timer = 0.2

func _physics_process(delta: float) -> void:
	take_input(delta)
	queue_redraw()
	
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
	move_horizontal(delta, move_direction.x)
#	velocity += acceleration * TILE_SIZE * move_direction
#	velocity.x = clamp(velocity.x, -max_speed, max_speed)
#	if is_zero_approx(move_direction.x):
#		velocity.x *= 0.8
	velocity.y += get_gravity() * delta
	velocity.y = min(velocity.y, max_falling_speed * TILE_SIZE)
	if jump_timer > 0 and is_on_floor():
		jump(jump_height)

	if Input.is_action_just_released("sel"):
		if velocity.y < -jump_hang_velocity:
			velocity.y *= 0.2
	
	is_on_ground = is_on_floor()
	
	move_and_slide()

func are_signs_equal(v1 : float, v2: float) -> bool:
	if v1 >= 0 and v2 >= 0:
		return true
	if v1 < 0 and v2 < 0:
		return true
	return false
