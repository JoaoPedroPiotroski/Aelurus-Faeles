extends Control

var governor : AllyFighter

signal action_chosen(action : BattleAction)
signal movement_started

@onready var mana : Label = $Mana
@onready var health : Label = $Health

func _process(delta):
	if governor:
		if governor.stats:
			update_labels()

func setup(p_governor):
	governor = p_governor
	
func update_labels():
	health.text = "HP: " + str(governor.stats.health) + "/" + str(governor.stats.max_health)
	mana.text = "MP: " + str(governor.stats.mana) + "/" + str(governor.stats.max_mana)
