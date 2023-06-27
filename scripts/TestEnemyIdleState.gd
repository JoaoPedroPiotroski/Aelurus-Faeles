extends State

@export var left_detector : RayCast2D
@export var right_detector : RayCast2D
@export var acceleration = 20
@export var player_detector : RayCast2D
var move_direction := Vector2.RIGHT
var switch_cooldown : float = 0.0

func _enter():
	pass
	
func _exit():
	pass

func _physics_process(delta: float) -> void:
	switch_cooldown -= delta
	body.velocity += move_direction * acceleration * delta
	if left_detector.is_colliding() and switch_cooldown < 0:
		switch_cooldown = 0.2
		move_direction = Vector2.RIGHT
	if right_detector.is_colliding() and switch_cooldown < 0:
		switch_cooldown = 0.2
		move_direction = Vector2.LEFT
	
	player_detector.target_position = move_direction * 50
	if player_detector.is_colliding():
		emit_signal("request_state", "TestChaseState")
