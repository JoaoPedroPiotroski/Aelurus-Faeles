@tool
extends Area2D

@export var width : int = 64
@export var height : int = 32
@export var height_offset : float = 2
@export var height_randomness : float = 2

var density = 100
var grass_tex = preload("res://scenes/field_tall_grass.tscn")
var grass_shader = preload("res://assets/shaders/grass_shader2.tres")

@onready var sprites: Node2D = $Sprites

func _ready() -> void:
	z_index = global_position.y
	spawn_field()

func spawn_grass(pos : Vector2):
	var frame = 0
	var rng = randi_range(0, 100)
	while rng > 65:
		rng = randi_range(0, 100)
		frame += 1
		if frame >= 3:
			break
	var inst = grass_tex.instantiate()
	sprites.add_child(inst)
	inst.position = pos + Vector2(0, pos.y + randf_range(-height_randomness, height_randomness))
	inst.frame = frame
	inst.z_index = inst.position.y
	inst.material = grass_shader
	
func spawn_row(pos, amount):
	for i in range(amount):
		if randi_range(0, 100) < 100 * smoothstep(-36, 16, pos.y):
			print(smoothstep(-36, 16, pos.y))
			spawn_grass(Vector2(
				pos.x + (i * 16), pos.y
			))

func spawn_field():
	for c in sprites.get_children():
		c.queue_free()
	for h in range(height):
		spawn_row(Vector2(
			0, height_offset * h
		), width)
		height_offset *= 0.9
		density -= 100 / height
