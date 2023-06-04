class_name StatusEffect
extends Node

var affected : Fighter

func _init() -> void:
	add_to_group("StatusEffects")

func _on_round_started():
	pass

func _on_round_ended():
	pass

func _on_turn_started(agitator : Fighter):
	pass

func _on_turn_ended(agitator : Fighter):
	pass
