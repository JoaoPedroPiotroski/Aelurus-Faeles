extends Camera2D

enum states {
	FOLLOW,
	BATTLE,
	STATIC
}
var state = states.FOLLOW
var target_pos := Vector2.ZERO
var target_zoom := Vector2(1, 1)

@export var target_ally : AllyFighter
@export var follow_offset : Vector2 = Vector2(0, -32)
@export var speed_offset_edge : float = 10.0
@export var offset_delta : float = 1
@export var opposite_direction_multiplier : float = 2.

func _process(delta):
	match(state):
		states.FOLLOW:
			_follow_state(delta)
	global_position = target_pos
	zoom = target_zoom
#	camera.drag_vertical_enabled = !is_on_floor()
#	if is_equal_approx(abs(velocity.x), max_speed):
#		camera.offset.x = lerp(camera.offset.x, move_direction * (max_speed), 0.5 * delta)
#	else:
#		camera.offset.x = lerp(camera.offset.x, 0.0, 1 * delta)
#	if not are_signs_equal(camera.offset.x, move_direction):
#		camera.offset.x = lerp(camera.offset.x, move_direction * (max_speed), delta)
#	camera.drag_horizontal_enabled = abs(velocity.x) < max_speed / 2.

func _follow_state(delta):
	
	if target_ally:
		
		drag_vertical_enabled = not target_ally.is_on_floor()
		if abs(target_ally.velocity.x) >= target_ally.max_speed - speed_offset_edge:
			var opposite = sign(target_ally.velocity.x) != sign(offset.x)
			offset.x = lerp(offset.x, target_ally.move_direction * (target_ally.max_speed), offset_delta * delta * (int(opposite) * opposite_direction_multiplier + 1.))
		else:
			offset.x = lerp(offset.x, 0.0, offset_delta * delta)
		target_pos = target_ally.global_position + Vector2(follow_offset)
		print("MX SPEED: ", target_ally.max_speed, " | VELOCITY: ", target_ally.velocity)
		print(abs(target_ally.velocity.x) < target_ally.max_speed / 2.)
		drag_horizontal_enabled = abs(target_ally.velocity.x) < target_ally.max_speed
