class_name State
extends Node

var body : Entity
signal request_state(String)

func _ready() -> void:
	var s_machine : StateMachine = get_parent()
	connect('request_state', s_machine.switch_state)
	
func _enter():
	pass
	
func _exit():
	pass
