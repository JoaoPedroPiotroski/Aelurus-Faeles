extends Node2D
class_name World

static var _instance : World
static var _levels : Node2D

func _ready():
	World._instance = self
	
	if not has_node("Levels"):
		var levels_node = Node2D.new() 
		add_child(levels_node)
		levels_node.name = "Levels"
	World._levels = get_node("Levels")
