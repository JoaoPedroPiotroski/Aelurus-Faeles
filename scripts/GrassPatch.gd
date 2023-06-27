@tool
extends Area2D

@export var extents : float = 0:
	set(value):
		extents = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export var grass_height : float = 1:
	set(value):
		grass_height = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export_category('layer')
@export var layers : float = 1:
	set(value):
		layers = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export var layer_x_delta : float = 0.5:
	set(value):
		layer_x_delta = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export var layer_y_delta : float = 0.1:
	set(value):
		layer_y_delta = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export_category('visual')
@export var grass_color : Color = Color.WHITE:
	set(value):
		grass_color = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export var color_randomness : float = 0.1:
	set(value):
		color_randomness = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()
@export var color_shadow : Color = Color(.1,.1,.1):
	set(value):
		color_shadow = value
		if !Engine.is_editor_hint():
			return
		create_grass_patch()

var g_blade_tex = preload("res://assets/images/grass_blade.png")
var grass_shader = preload("res://assets/shaders/grass_shader.tres")
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var blades: Node2D = $Blades

func _ready() -> void:
	create_grass_patch()
	
func create_grass_patch():
	#collision_shape_2d.shape.set_deferred("size:x", extents)
	collision_shape_2d.shape.size = Vector2(extents, 4 * grass_height)
	collision_shape_2d.position.y = -4 * grass_height / 2
	for blade in blades.get_children():
		blade.queue_free()
	var blade_height : float = 1.0
	for layer in range(layers):
		for x in range(-extents, extents, 2):
			var blade := Sprite2D.new()
			blade.texture = g_blade_tex
			blade.centered = false
			#blade.self_modulate = grass_color + Color(0, randf_range(-color_randomness, color_randomness), 0) - (color_shadow * layer)
			blade.scale.x = 0.75
			blade.visibility_layer = visibility_layer
			blade.scale.y = blade_height * grass_height
			blade.z_index = layer
			#print('camada: ', layer)
			#print('escala: ', blade.scale.y)
			blades.add_child(blade)
			blade.material = grass_shader
			blade.material.set('shader_parameter/base_color', grass_color + Color(0, randf_range(-color_randomness, color_randomness), 0))
			blade.material.set('shader_parameter/shadow_color', color_shadow)
			blade.material.set('shader_parameter/shadow_mix', (1. / layers) * layer)
			blade.position.x = float(x) + (layer_x_delta * layer)
			blade.position.x /= 2
			blade.position.y += 1. - blade.scale.y * 4
			
			#print((1. / (layer+1.)))
		blade_height += layer_y_delta
