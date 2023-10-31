extends Control
class_name PApp

signal app_close
signal app_main_screen_request

@export var title : String = ''
@export_file("*.png") var icon_path : String
@onready var console : Console = get_parent().get_parent().get_parent()

func _ready():
	emit_signal("app_main_screen_request")

