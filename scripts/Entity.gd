class_name Entity
extends CharacterBody2D

var move_direction : Vector2 = Vector2.ZERO

func _ready():
	add_to_group('entities')
