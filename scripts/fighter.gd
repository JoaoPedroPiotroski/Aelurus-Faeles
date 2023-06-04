class_name Fighter
extends Node

# Overall stats
var max_health : float
var max_mana : float
var strength : float 
var defense : float
var speed : float

# Base stats
var base_max_health : float
var health : float
var base_max_mana : float
var mana : float
var base_strength : float 
var base_defense : float
var base_speed : float

# Battle stats
var base_initiative : float
var additional_initiative : float = 0
var actions : Array[BattleAction] 
var status_effects : Array[StatusEffect]

# Extra stats
var extra_health : float = 0
var extra_mana : float = 0
var extra_strength : float = 0
var extra_defense : float = 0
var extra_speed : float = 0

func _init() -> void:
	add_to_group("Fighters")

func _on_round_start():
	extra_health = 0
	extra_mana = 0
	extra_strength = 0
	extra_defense = 0
	extra_speed = 0
	max_health = base_max_health + extra_health
	max_mana = base_max_mana + extra_mana
	strength = base_strength + extra_strength
	defense = base_defense + extra_defense
	speed = base_speed + extra_speed

func _on_round_end():
	pass
	
func _on_turn_start(agitator : Fighter):
	pass

func _on_turn_end(agitator : Fighter):
	pass
