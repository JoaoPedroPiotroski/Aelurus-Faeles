extends CharacterBody2D

var acceleration = 10
var max_speed = 80
var friction = 0.95
var gravity = 8
var jump_force = 180

var jump_timer : float = 0
var move_dir : Vector2 = Vector2.ZERO

@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite

func take_input(delta : float):
	jump_timer -= delta
	move_dir = Vector2.ZERO
	move_dir.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if Input.is_action_just_pressed("sel"):
		jump_timer = 0.2

func _physics_process(delta: float) -> void:
	take_input(delta)
	
	if velocity.x != 0:
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play('walk')
		sprite.flip_h = velocity.x < 0
	else:
		$AnimationPlayer.stop()
		
	camera.drag_vertical_enabled = !is_on_floor()
	if is_equal_approx(abs(velocity.x), max_speed):
		camera.offset.x = lerp(camera.offset.x, move_dir.x * (max_speed), 0.5 * delta)
	else:
		camera.offset.x = lerp(camera.offset.x, 0.0, 1 * delta)
	if not are_signs_equal(camera.offset.x, move_dir.x):
		camera.offset.x = lerp(camera.offset.x, move_dir.x * (max_speed), delta)
	camera.drag_horizontal_enabled = abs(velocity.x) < max_speed / 2
	velocity += acceleration * move_dir
	velocity.x *= friction
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	if is_zero_approx(move_dir.x):
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
