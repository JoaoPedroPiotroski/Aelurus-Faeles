extends AudioStreamPlayer

signal current_time_update(float)
@onready var music: AudioStreamPlayer = $"../Music"
@onready var car: CharacterBody2D = $"../World/Car"

@export_node_path('RaceCheckpoint') var finish_line

var countdown : int = 2

func _on_timer_timeout() -> void:
	countdown-=1
	emit_signal("current_time_update", countdown + 1)
	if countdown < 0:
		music.play()
		car.race_started = true
		get_node(finish_line).race_started = true
		queue_free()
