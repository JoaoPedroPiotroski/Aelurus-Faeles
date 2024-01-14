extends Camera2D
class_name GameCamera

enum states {
	FOLLOW,
	BATTLE,
	STATIC
}
var state = states.FOLLOW
var target_pos := Vector2.ZERO
var target_zoom := Vector2(1, 1)
static var _instance : Camera2D

var zooming_out = false
var settled_zoom : Vector2
var object_queue = 0
@export var zoom_min = 0.01
@export var zoom_max = 5.0
@export var zoom_margin : Vector2 = Vector2(25, 25)
@export var target_ally : AllyFighter
@export var follow_offset : Vector2 = Vector2(0, -32)
@export var speed_offset_edge : float = 10.0
@export var offset_delta : float = 1
@export var opposite_direction_multiplier : float = 2.

func _ready():
	_instance = self

func _process(delta):
	if Global.in_battle:
		state = states.BATTLE
	match(state):
		states.FOLLOW:
			_follow_state(delta)
		states.BATTLE:
			_battle_state(delta)
	global_position = target_pos
	zoom = lerp(zoom, target_zoom, delta * 0.5)
#	camera.drag_vertical_enabled = !is_on_floor()
#	if is_equal_approx(abs(velocity.x), max_speed):
#		camera.offset.x = lerp(camera.offset.x, move_direction * (max_speed), 0.5 * delta)
#	else:
#		camera.offset.x = lerp(camera.offset.x, 0.0, 1 * delta)
#	if not are_signs_equal(camera.offset.x, move_direction):
#		camera.offset.x = lerp(camera.offset.x, move_direction * (max_speed), delta)
#	camera.drag_horizontal_enabled = abs(velocity.x) < max_speed / 2.

func _battle_state(delta):
	var follow_group : Array[Fighter]
	follow_group.append_array( Global.party ) 
	follow_group.append_array( Global.enemies ) 
	if follow_group.size() > 1:
		var avg_pos : Vector2
		var rect: Rect2 = Rect2(target_ally.get_global_position(), Vector2.ZERO)
		var screen_size: Vector2 = get_viewport_rect().size
		for node in follow_group:
			node.modulate = Color.RED
			avg_pos += node.global_position
			rect = rect.expand(node.get_global_position())
			rect = rect.grow_individual(
				zoom_margin.x,
				zoom_margin.y,
				zoom_margin.x,
				zoom_margin.y)
			
		if rect.size.x > rect.size.y * screen_size.aspect():
			target_zoom = clamp(screen_size.x / rect.size.x , zoom_min, zoom_max) * Vector2.ONE
		else:
			target_zoom = clamp(screen_size.y / rect.size.y , zoom_min, zoom_max) * Vector2.ONE
		
		target_pos = lerp(global_position, rect.get_center(), delta * 0.5)


func _follow_state(delta):
	if target_ally:
		#if abs(target_ally.velocity.length()) >= target_ally.max_speed - speed_offset_edge:
		if target_ally.move_direction != Vector2.ZERO:
			var opposite = sign(target_ally.velocity.x) != sign(offset.x)
			offset = lerp(offset, target_ally.move_direction * (target_ally.max_speed), offset_delta * delta * (int(opposite) * opposite_direction_multiplier + 1.))
		else:
			offset = lerp(offset, Vector2.ZERO, offset_delta * delta)
		target_pos = target_ally.global_position + Vector2(follow_offset)
		#drag_horizontal_enabled = abs(target_ally.velocity.x) < target_ally.max_speed - 10.0
		#drag_vertical_enabled = abs(target_ally.velocity.y) < target_ally.max_speed - 10.0
