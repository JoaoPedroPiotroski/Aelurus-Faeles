class_name Enemy
extends Entity

var components : Array[Component] = []
var enemies_found : Array[Enemy] = []
@onready var propagator = preload("res://scenes/enemy_propagator.tscn")

func _ready() -> void:
	add_to_group('enemies')
	for child in get_children():
		if child is Component:
			components.append(child)

func stop() -> void:
	for component in components:
		component.disable()

func restart() -> void:
	for component in components:
		component.enable()

func propagate(starter : Enemy) -> void:
	if starter.enemies_found.size() >= 3:
		start_battle()
		get_tree().call_group('enemy_finders', 'cancel')
		return
	get_tree().call_group('enemies', 'stop')
	print('\n----\nPROPAGANDO DE: ', name)
	var p_inst := propagator.instantiate() 
	p_inst.governor = starter
	p_inst.connect('nothing_found', starter.start_battle)
	p_inst.connect('propagate_found', starter._on_enemy_found)
	call_deferred('add_child', p_inst)
	
func start_battle():
	print('É HORA DO DUELO')

func _on_enemy_found(enemy : Enemy):
	if not enemies_found.has(enemy) and enemy != self and enemies_found.size() < 3:
		enemies_found.append(enemy)
	if enemies_found.size() >= 3:
		get_tree().call_group('enemy_finders', 'cancel')
	print('find_amount: ', enemies_found.size())
	print('find_list: ', enemies_found)

func _on_player_found(_player ):
	pass
	
func _on_player_lost():
	pass

func _on_player_touch(_player : Node2D):
	propagate(self)
