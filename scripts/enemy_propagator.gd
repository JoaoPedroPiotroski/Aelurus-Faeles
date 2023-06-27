class_name EnemyPropagator
extends Area2D

signal nothing_found
signal propagate_found(Enemy)

var cancelled = false
var found_something = false
var governor : Enemy

@onready var tween = get_tree().create_tween()
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var polygon_2d: Polygon2D = $Polygon2D

func _ready() -> void:
	add_to_group('enemy_finders')
	_propagate()

func _propagate():
	tween.tween_property(collision_shape_2d.shape, "radius", 80, .4)
	tween.tween_property(polygon_2d, "scale", Vector2(80, 80), .4)
	tween.tween_callback(_on_anim_end)

func cancel():
	tween.stop()
	cancelled = true
	queue_free()

func _on_anim_end():
	if not found_something:
		emit_signal('nothing_found')
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if cancelled:
		return
	if body is Enemy and body != governor and not governor.enemies_found.has(body) and not cancelled:
		found_something = true
		body.propagate(governor)
		emit_signal("propagate_found", body)
