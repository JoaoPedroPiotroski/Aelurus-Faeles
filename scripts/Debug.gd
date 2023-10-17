extends Node

enum {
	SEVERITY_LOW,
	SEVERITY_MED,
	SEVERITY_HIGH
}
var loading_debug_lines : Array[String] = []
var loading_debug_severity : Array[int] = []
var loading_debug : bool = false

func _process(_delta) -> void:
	if loading_debug:
		if loading_debug_lines.size() > 0:
			print("LOADING DEBUG [", Time.get_datetime_string_from_system(), "]")
		for i in range(loading_debug_lines.size()):
			match(loading_debug_severity[i]):
				SEVERITY_HIGH:
					push_error(loading_debug_lines[i])
				SEVERITY_LOW:
					print(loading_debug_lines[i])
				SEVERITY_MED:
					push_warning(loading_debug_lines[i])
	loading_debug_lines = []
	loading_debug_severity = []
	
func load_out(_new_line : String, _severity = SEVERITY_LOW) -> void:
	loading_debug_lines.append(_new_line)
	loading_debug_severity.append(_severity)
