class_name RaceCheckpoint
extends Area2D

var lap_timer : float = 0
var last_lap : float = 0
var best_lap : float = 0
var race_started = false

signal high_time_update(float)
signal current_time_update(float)
signal last_time_update(float)

@export_node_path('RaceCheckpoint') var previous
@export_node_path('RaceCheckpoint') var next 
@export_node_path('Control') var lap_display
@export var finish_line : bool = false

func _ready():
	body_entered.connect(_on_body_entered)
	if finish_line:
		high_time_update.connect(get_node(lap_display)._on_update_high_time)
		current_time_update.connect(get_node(lap_display)._on_update_current_time)
		last_time_update.connect(get_node(lap_display)._on_update_last_time)
	
func _process(delta):
	if finish_line and race_started: 
		lap_timer += delta
		emit_signal('current_time_update', lap_timer)
	
func _on_body_entered(body: Node2D):
	if body is RacingCar:
		if body.current_checkpoint == get_node(previous):
			body.current_checkpoint = self
			if finish_line:
				last_lap = lap_timer
				emit_signal('last_time_update', last_lap)
				if lap_timer < best_lap or best_lap == 0:
					best_lap = lap_timer
					emit_signal('high_time_update', best_lap)
				lap_timer = 0
