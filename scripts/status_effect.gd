class_name StatusEffect
extends Node

@export var duration : int = -1
var start_time : int
var affected : Fighter 

func _init() -> void:
	add_to_group("StatusEffects")
	start_time = affected.rounds

func _on_round_started():
	if duration != -1:
		if affected.rounds - start_time >= duration:
			queue_free()

func _on_round_ended():
	pass

func _on_turn_started(agitator : Fighter):
	pass

func _on_turn_ended(agitator : Fighter):
	pass
