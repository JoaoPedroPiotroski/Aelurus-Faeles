extends NinePatchRect

signal action_chosen

@export var battle_buttons : Array
@export_node_path var def_position_path
var def_position : Vector2

func _ready():
	def_position = get_node(def_position_path).global_position
	battle_buttons += [$Button1,$Button2,$Button3,$Button4]
	$Button1.grab_focus()
	
	var id = 0
	for button in battle_buttons: 
		button.id = id
		id+=1
		button.def_position = def_position
		for button2 in battle_buttons:
			button.button_selected.connect(button2._on_button_selected)
			button.button_deselect.connect(button2._on_button_deselected)
			button.accumulate_end.connect(button2._on_accumulate_end)
