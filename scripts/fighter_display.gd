extends Control

var fighter_owner : Fighter

@onready var name_label = $Name
@onready var health_label = $Health
@onready var mana_label = $Mana

func set_fighter_name(p_name : String) -> void:
	name_label.text = p_name
	
func set_fighter_health(p_health : String) -> void:
	health_label.text = str(p_health)
	
func set_fighter_mana(p_mana : float) -> void:
	mana_label.text = str(p_mana)
