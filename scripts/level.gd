extends Node2D
class_name Level

@export var level_name : String

static var current_level : Level = null :
	set(value):
		Debug.load_out('new current level: ' + value.name)
		current_level = value
static var loaded_levels : Array[Level] = []
static var async_loading_paths : Array[String] = []

var outside_connections : Array[LevelOutsideConnection]

func _ready():
	if has_node("LevelPlayArea"):
		var level_play_area : Area2D = get_node("LevelPlayArea")
		level_play_area.connect("body_entered", _on_LevelPlayArea_body_entered)
		level_play_area.connect("body_exited", _on_LevelPlayArea_body_exited)
		
	if has_node("OutsideConnections"):
		for con in get_node("OutsideConnections").get_children():
			if con is LevelOutsideConnection:
				outside_connections.append(con)
				
	if not self in loaded_levels:
		loaded_levels.append(self)
		
func _process(delta):
	for loading_level in async_loading_paths:
		match(ResourceLoader.load_threaded_get_status(loading_level)):
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				Debug.load_out("LEVEL LOADING PROGRESS")
				continue
			ResourceLoader.THREAD_LOAD_LOADED:
				Debug.load_out("LEVEL LOADING SUCCESS FOR " + loading_level)
				var new_level = ResourceLoader.load_threaded_get(loading_level)
				var level_instance = new_level.instantiate()
				World._levels.add_child(level_instance)
				level_instance.global_position = Vector2(0, 0)
				level_instance.name = level_instance.level_name
				if Level.current_level:
					for con in Level.current_level.outside_connections:
						for con2 in level_instance.outside_connections:
							if (con.target_level == level_instance.level_name
							and con2.target_level == Level.current_level.level_name): 
								level_instance.global_position = current_level.global_position - con2.position + con.position
				continue
			ResourceLoader.THREAD_LOAD_FAILED:
				Debug.load_out("LEVEL LOADING FAILED FOR " + loading_level +"\nTHREAD_LOAD_FAILED", Debug.SEVERITY_HIGH)
				async_loading_paths.erase(loading_level)
				continue
			ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
				Debug.load_out("LEVEL LOADING FAILED FOR " + loading_level +"\nTHREAD_LOAD_INVALID_RESOURCE", Debug.SEVERITY_LOW)
				async_loading_paths.erase(loading_level)
				continue

static func build_level_file_path(_name : String) -> String:
	return "res://scenes/levels/" + _name + ".tscn"
	
static func load_new_level(_level_path : String) -> void:
	Debug.load_out("REQUEST TO LOAD LEVEL: " + _level_path)
	if ResourceLoader.exists(_level_path) and not ResourceLoader.has_cached(_level_path):
		Debug.load_out("LEVEL PATH EXISTS")
		ResourceLoader.load_threaded_request(_level_path)
		Level.async_loading_paths.append(_level_path)
	else:
		Debug.load_out("LEVEL LOADING FAILED: SPECIFIED PATH " + _level_path + " DOESN'T EXIST", Debug.SEVERITY_HIGH)

func load_connections():
	var loaded_level_names : Array[String] = []
	for loaded_level in Level.loaded_levels:
		loaded_level_names.append(loaded_level.level_name)
		
	for new_con in outside_connections:
		if new_con.target_level in loaded_level_names:
			continue
			
		var path = Level.build_level_file_path(new_con.target_level)
		Level.load_new_level(path)
	
func unload_connections():
	var keep_levels : Array[String] = []
	Debug.load_out('request unload')
	for current_con in Level.current_level.outside_connections:
		keep_levels.append(current_con.target_level)
		
	for loaded_level in Level.loaded_levels:
		if keep_levels.has(loaded_level.level_name) or loaded_level.level_name == current_level.level_name:
			continue
		else:
			Debug.load_out("Keep levels: " + str(keep_levels))
			Debug.load_out('Unloading: ' + loaded_level.name)
			loaded_level.queue_free()

func _on_LevelPlayArea_body_entered(_body : Node2D):
	if _body is Player:
		print('player entered', self)
		var old_level : Level = null
		old_level = Level.current_level
		Level.current_level = self
		load_connections()
		if old_level:
			old_level.unload_connections()
	if _body is Entity and not _body is Player:
		_body.call_deferred("reparent", self)

func _on_LevelPlayArea_body_exited(_body):
	if _body is Player:
		print('player left', self)
	#unload_connections()
		
func _exit_tree():
	Level.loaded_levels.erase(self)
