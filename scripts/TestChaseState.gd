extends State

@export var acceleration = 20
@export var player_detector : RayCast2D
var last_player_pos : Vector2
var player_timer : float = 2.

func _enter():
	player_timer = 2.

func _physics_process(delta: float) -> void:
	var seeing_player := false
	return

