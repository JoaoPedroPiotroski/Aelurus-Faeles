class_name BattleAction
extends Node

var governor : Fighter

@export var title : String
@export var mana_cost : int = 0
@export var target_type : BattleController.TARGETS = BattleController.TARGETS.ENEMY # target type in BattleController class

signal choose_target(int)

func assign_governor(new_governor : Fighter):
	governor = new_governor

func _on_action_selected():
	emit_signal('request_target', target_type)
	
func _on_target_selected(target : Fighter):
	governor.stats.mana -= mana_cost
