class_name PMainButton
extends TextureButton

@export_file('*.tscn') var app_path : String
@export var is_system_app : bool = false

signal app_load_request(String)
signal selection_change(Vector2)

func _ready():
	focus_entered.connect(_on_focus_entered)
	pressed.connect(_on_button_pressed)

func _on_focus_entered():
	emit_signal("selection_change", global_position)
	
func _on_focus_exited():
	pass
	
func _on_button_pressed():
	emit_signal("app_load_request", app_path)
	
