class_name Entity
extends CharacterBody2D

var components : Array[Component]

func _ready():
	add_to_group('entities')
	for child in get_children():
		if child is Component:
			components.append(child)

func stop() -> void:
	for component in components:
		component.disable()

func restart() -> void:
	for component in components:
		component.enable()
