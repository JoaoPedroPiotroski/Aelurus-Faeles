extends Control

@onready var high_score: Label = $HBoxContainer/HighScore
@onready var current: Label = $HBoxContainer/Current
@onready var last_score: Label = $HBoxContainer/LastScore

func _on_update_high_time(new_value : float):
	high_score.text = str(int(new_value))
	
func _on_update_current_time(new_value : float):
	current.text = str("%.2f" % (new_value))

func _on_update_last_time(new_value : float):
	last_score.text = str(int(new_value))
