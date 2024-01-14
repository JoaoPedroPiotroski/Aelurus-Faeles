class_name EnemyFighter
extends Fighter

@export var speed = 30

@export var player_detector_npath : NodePath
@onready var player_detector : Area2D = get_node_or_null(player_detector_npath)
@export var player_collider_npath : NodePath
@onready var player_collider : Area2D = get_node_or_null(player_collider_npath)
@onready var stats_display = preload("res://scenes/enemy_fighter_display.tscn")

enum CONTROL_STATES {
	WANDER,
	BATTLE
}
var CONTROL_STATE = CONTROL_STATES.WANDER

var player : AllyFighter

var battle_target_pos := Vector2.ZERO
var battle_distance := 256.0
var move_dir := Vector2.ZERO
var nav_agent : NavigationAgent2D
var starting_pos := Vector2.ZERO

func _ready():	
	super()
	add_to_group("EnemyFighters")
	nav_agent = NavigationAgent2D.new()
	add_child(nav_agent)
	nav_agent.debug_enabled = true 
	if player_detector:
		player_detector.body_entered.connect(_on_player_detector_body_entered)
		player_detector.body_exited.connect(_on_player_detector_body_exited)
	if player_collider:
		player_collider.body_entered.connect(_on_player_collider_body_entered)
	await get_tree().create_timer(0.5).timeout
	starting_pos = global_position
	

func _physics_process(delta):
	match(CONTROL_STATE):
		CONTROL_STATES.WANDER:
			_wander_state(delta)
		CONTROL_STATES.BATTLE:
			_battle_controlled(delta)

func _wander_state(delta):
	var target_pos := Vector2.ZERO
	if player:
		target_pos = player.global_position
	else:
		target_pos = starting_pos
	move_dir = global_position.direction_to(target_pos)
	velocity = move_dir * speed
	move_and_slide()

func _battle_controlled(delta):
	nav_agent.target_position = battle_target_pos
	if nav_agent.is_target_reachable() and not nav_agent.is_target_reached():
		var next_point = nav_agent.get_next_path_position()
		move_dir = global_position.direction_to(next_point)
		velocity = move_dir * speed
		if (global_position.distance_to(battle_target_pos) < 32):
			velocity = Vector2.ZERO
			global_position = lerp(global_position, battle_target_pos, 1.0 * delta)
	move_and_slide()
	queue_redraw()

func _draw():
	draw_circle(to_local(battle_target_pos), 5, Color.BLUE_VIOLET)

func prepare_for_battle():
	var display = stats_display.instantiate()
	add_child(display)
	if has_node("StatsPosition"):
		display.position = get_node("StatsPosition").position
	display.governor = self
	battle_target_pos = starting_pos
	CONTROL_STATE = CONTROL_STATES.BATTLE

func _on_player_detector_body_entered(body : Node2D):
	if body is AllyFighter and not Global.in_battle:
		body = body as AllyFighter
		if body.CONTROL_STATE == body.CONTROL_STATES.PLAYER:
			player = body

func _on_player_detector_body_exited(body : Node2D):
	if body == player and not Global.in_battle:
		player = null

func _on_player_collider_body_entered(body : Node2D):
	if body is AllyFighter and not Global.in_battle:
		body = body as AllyFighter
		if body.CONTROL_STATE == body.CONTROL_STATES.PLAYER:
			var c_enemies := get_tree().get_nodes_in_group("EnemyFighters")
			var battle_enemies := [self]
			var complete = false
			while not complete:
				var enemy_added = false
				for enemy in c_enemies:
					if enemy.global_position.distance_to(self.global_position) < battle_distance * 1000 and not enemy in battle_enemies and battle_enemies.size() < 100:
						battle_enemies.append(enemy)
						enemy_added = true
				complete = not enemy_added
			Global.start_battle(battle_enemies)
