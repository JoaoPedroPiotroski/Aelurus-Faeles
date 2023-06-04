class_name Console
extends Control

const BOOT_PATH : String = "res://scenes/p_apps/boot_screen.tscn"
const MAIN_SCREEN_PATH : String = "res://scenes/p_apps/main_screen.tscn"

var installed_apps : Array[String] = [
	"res://scenes/p_apps/racing.tscn",
	"res://scenes/p_apps/odissey.tscn"
] : get = get_installed_apps # caminhos dos apps instalados

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport

func _ready():
	boot()
	
func get_installed_apps():
	return installed_apps

func boot():
	load_path(BOOT_PATH)
	
func go_to_main_screen():
	load_path(MAIN_SCREEN_PATH)

func load_path(path : String):
	var res = load(path)
	var inst : PApp = res.instantiate()
	for child in sub_viewport.get_children():
		child.queue_free()
	sub_viewport.add_child(inst)
	inst.app_close.connect(_on_app_close)
	inst.app_main_screen_request.connect(_on_app_main_screen_requested)

func load_app(title : String):
	pass
	
func _on_app_main_screen_requested():
	go_to_main_screen()

func _on_app_close():
	pass
	
