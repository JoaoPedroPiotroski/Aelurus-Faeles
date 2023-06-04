extends NinePatchRect

signal action_chosen

@export var battle_buttons : Array
@export_node_path var def_position_path
@export_node_path('Button') var attack_button_path
@export_node_path('Button') var protect_button_path
@export_node_path('Button') var magic_button_path
@export_node_path('Button') var artifact_button_path
var attack_button
var protect_button
var magic_button
var artifact_button
var def_position : Vector2

func _ready():
	attack_button = get_node(attack_button_path)
	protect_button = get_node(protect_button_path)
	magic_button = get_node(magic_button_path)
	artifact_button = get_node(artifact_button_path)
	def_position = get_node(def_position_path).global_position
	battle_buttons += [attack_button, protect_button, magic_button, artifact_button]
	attack_button.grab_focus()
	
	var id = 0
	for button in battle_buttons: 
		button.id = id
		id+=1
		button.def_position = def_position
		for button2 in battle_buttons:
			button.button_selected.connect(button2._on_button_selected)
			button.button_deselect.connect(button2._on_button_deselected)
			button.accumulate_end.connect(button2._on_accumulate_end)
