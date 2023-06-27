extends State

@export var acceleration = 20
@export var player_detector : RayCast2D
var last_player_pos : Vector2
var player_timer : float = 2.

func _enter():
	player_timer = 2.

func _physics_process(delta: float) -> void:
	var seeing_player := false
	player_detector.target_position = body.move_direction * 50
	if player_detector.is_colliding():
		seeing_player = true
		player_timer = 2.
		last_player_pos = player_detector.get_collider().global_position
	
	if not seeing_player:
		player_timer -= delta
	
	if player_timer < 0.:
		emit_signal("request_state", "TestIdleState")
	body.move_direction = body.global_position.direction_to(last_player_pos)
	body.velocity.x += acceleration * body.move_direction.x * delta
