class_name Component
extends Node

var parent : CharacterBody2D
var enabled : bool = true

func _ready() -> void:
	parent = get_parent()

func disable() -> void:
	set_physics_process(false)
	set_process(false)
	enabled = false
	
func enable() -> void:
	set_physics_process(true)
	set_process(true)
	enabled = true
