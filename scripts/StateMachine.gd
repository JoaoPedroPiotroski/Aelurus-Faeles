class_name StateMachine
extends Node

@export var state : State
var states : Dictionary = {}

func _ready() -> void:
	for s in get_children():
		if s is State:
			states[s.name] = s
			s.body = get_parent()
			s.process_mode = Node.PROCESS_MODE_DISABLED
	states[state.name].process_mode = Node.PROCESS_MODE_ALWAYS
		
func switch_state(s_name : String):
	if state.name != s_name:
		state._exit()
		state.process_mode = Node.PROCESS_MODE_DISABLED
		state = states[s_name]
		state.process_mode = Node.PROCESS_MODE_INHERIT
		state._enter()
