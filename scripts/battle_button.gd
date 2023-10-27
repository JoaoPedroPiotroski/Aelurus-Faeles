class_name BattleButton
extends Button

var initial_position : Vector2 = Vector2.ZERO
var def_position : Vector2
var prev_neighbor_left
var prev_neighbor_right
var initial_size
var id = 0
var is_button_selected = false

signal button_selected(BattleButton)
signal button_deselect
signal accumulate_end

func _ready():
	initial_position = global_position
	initial_size = size
	pressed.connect(_on_self_pressed)
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("act") and is_button_selected:
		emit_signal('button_deselect')
	
func _on_focus_entered():
	var tween = get_tree().create_tween(
	).bind_node(self).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", global_position.y - 5, 0.2)
	
func _on_focus_exited():
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "global_position", initial_position	, 0.1)
	
func _on_self_pressed():
	emit_signal('button_selected', self)

func _on_button_selected(sel_btn : BattleButton):
	is_button_selected = true
	prev_neighbor_left = focus_neighbor_left
	prev_neighbor_right = focus_neighbor_right
	focus_neighbor_left = ""
	focus_neighbor_right = ""
	if sel_btn == self:
		z_index = 4
	else:
		focus_mode = Button.FOCUS_NONE
		z_index = sel_btn.id-id
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "global_position", sel_btn.global_position, 0.2)
		tween.tween_property(self, "size", sel_btn.size, 0.2)		
		var tween2 = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween2.tween_property(self, "self_modulate", Color(1, 1, 1, 0), 0.2)
		tween.tween_callback(self.emit_signal.bind('accumulate_end'))

func _on_accumulate_end():
	if is_button_selected:
		var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "global_position", def_position + Vector2(0, -5), 0.2)
		focus_mode = Button.FOCUS_ALL

func _on_button_deselected():
	is_button_selected = false
	focus_mode = Button.FOCUS_ALL
	z_index = 0
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	if has_focus():
		tween.tween_property(self, "global_position", initial_position+Vector2(0, -5), 0.2)
	else:
		tween.tween_property(self, "global_position", initial_position, 0.2)
	tween.tween_property(self, "size", initial_size, 0.2)
	var tween2 = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween2.tween_property(self, "self_modulate", Color(1, 1, 1, 1), 0.2)
	focus_neighbor_left = prev_neighbor_left
	focus_neighbor_right = prev_neighbor_right
	
		
