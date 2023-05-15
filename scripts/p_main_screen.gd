extends PApp

@onready var app_grid: GridContainer = $AppGrid
@onready var selected: Sprite2D = $selected

func _ready():
	app_grid.create_app_list(console.get_installed_apps())

func move_selection(new_pos : Vector2):
	selected.global_position = new_pos + Vector2(8, 8)
	
func _on_app_load_request(path : String):
	console.load_path(path)
