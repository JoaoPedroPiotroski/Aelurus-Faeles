class_name BattleAction
extends Resource

@export var title : String
@export var mana_cost : int = 0
@export_flags("Damaging", "Healing", "Buffing") var action_type : int = 1
@export_group("Damaging")
@export var damage : float = 0
@export_group("Healing")
@export var heal_amount : float = 0
@export_group("Buffing")
@export_file var buff_type : String

enum action_types {
	Damaging = 1,
	Healing = 2,
	Buffing = 4
}

func _ready():
	_on_target_selected(Fighter.new(), Fighter.new())
	
func _on_target_selected(_governor : Fighter, target : Fighter):
	#governor.stats.mana -= mana_cost
	if action_type & action_types.Damaging != 0:
		print("Damaging Action")
		target.stats.health -= max(1, damage * (1.0 / target.stats.defense))
	if action_type & action_types.Healing != 0:
		print("Healing Action")
	if action_type & action_types.Buffing != 0:
		print("Buffing Action")
