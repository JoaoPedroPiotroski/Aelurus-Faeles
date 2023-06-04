class_name BattleAction
extends Node

var title : String
var target_type : int = BattleController.TARGETS.ENEMY # target type in BattleController class

signal choose_target(int)

func _on_action_selected():
	emit_signal('request_target', target_type)
	
func _on_target_selected(target : Fighter):
	pass
