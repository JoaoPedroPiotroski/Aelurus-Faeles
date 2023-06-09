class_name Fighter
extends Node

@export var stats : FighterStats
var actions : Array[BattleAction]
var status_effects : Array[StatusEffect]
var rounds : int = 0
var turns : int = 0

func _init() -> void:
	add_to_group("Fighters")

func _ready() -> void:
	for act_path in stats.action_paths:
		actions.append(load(act_path))

func _on_round_start():
	return
	@warning_ignore("unreachable_code")
	stats.extra_health = 0
	stats.extra_mana = 0
	stats.extra_strength = 0
	stats.extra_defense = 0
	stats.extra_speed = 0
	stats.max_health = stats.base_max_health + stats.extra_health
	stats.max_mana = stats.base_max_mana + stats.extra_mana
	stats.strength = stats.base_strength + stats.extra_strength
	stats.defense = stats.base_defense + stats.extra_defense
	stats.speed = stats.base_speed + stats.extra_speed

func _on_round_end():
	rounds += 1
	
func _on_turn_start(agitator : Fighter):
	pass

func _on_turn_end(agitator : Fighter):
	turns += 1
