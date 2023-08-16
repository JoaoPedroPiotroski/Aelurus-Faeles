extends Area2D

@export var path : String = ""
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().change_scene_to_file(path)
