extends GridContainer

var apps : Array[String] = []

func _ready():
	pass

func create_app_list(app_list):
	for app in app_list:
		var l_app : Resource = load(app) 
		var i_app = l_app.instantiate()
		var button : PMainButton = PMainButton.new()
		add_child(button)
		button.selection_change.connect(get_parent().move_selection)
		button.app_load_request.connect(get_parent()._on_app_load_request)
		button.app_path = app
		button.texture_normal = load(i_app.icon_path) if (i_app.icon_path.length() > 0) else null
		i_app.queue_free()
	for app in get_children():
		if not app.is_system_app:
			move_child(app, 0)
	get_child(0).grab_focus()
