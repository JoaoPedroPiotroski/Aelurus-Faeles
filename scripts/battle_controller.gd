extends Control

var fighters : Array[Fighter] = [] :
	set(value):
		allies = []
		enemies = []
		fighters = value
		for f in fighters:
			if f is AllyFighter:
				allies.append(f)
			elif f is EnemyFighter:
				enemies.append(f)
var allies : Array[AllyFighter] = []
var enemies : Array[EnemyFighter] = []
var selected_fighter : Fighter
var focused_fighter : Fighter

const FIGHTER_TURN_ICON = preload("res://scenes/fighter_turn_icon.tscn")

@onready var turn_order_icons = $CanvasLayer/Control/TurnOrder
var turn_order : Array[Fighter]

func roll_initiative():
	# FIXME eu to instanciando e depois mudando a ordem, n faz nenhum sentido oq eu to fazendo
	# só vou deixar como ta pq o importante é ter uma ordem funcionando
	for c in turn_order_icons.get_children():
		c.queue_free()
	for fighter in fighters:
		var initiative_roll = randi_range(1, 20)
		initiative_roll += fighter.stats.initiative 
		var t_icon = FIGHTER_TURN_ICON.instantiate()
		turn_order_icons.add_child(t_icon)
		t_icon.icon = fighter.icon
		t_icon.fighter = fighter
	var t_icons = turn_order_icons.get_children()
	var sorted = false
	while not sorted:
		sorted = true
		for i in range(t_icons.size()-1):
			if t_icons[i].fighter.stats.initiative < t_icons[i+1].fighter.stats.initiative:
				var temp = t_icons[i]
				sorted = false
				t_icons[i] = t_icons[i+1]
				t_icons[i+1] = temp
	turn_order = []
	for t_icon in turn_order_icons.get_children():
		turn_order.append(t_icon.fighter)

func start_battle():
	visible = true
	roll_initiative()
	focus_camera(turn_order[0])
	print(turn_order)
	
func focus_camera(tgt : Fighter):
	focused_fighter = tgt
