class_name FighterStats
extends Resource

# Overall stats
var max_health : float:
	set(value):
		if value > max_health:
			health += value-max_health
		max_health = value
		health = min(health, max_health)
var max_mana : float:
	set(value):
		if value > max_mana:
			mana += value-max_mana
		max_mana = value
		mana = min(mana, max_mana)
var strength : float
var defense : float
var speed : float

# Base stats
@export var base_max_health : float :
	set(value):
		base_max_health = value
		max_health = base_max_health + extra_health
var health : float :
	set(value):
		health = min(value, max_health)
@export var base_max_mana : float :
	set(value):
		base_max_mana = value
		max_mana = base_max_mana + extra_mana
var mana : float
@export var base_strength : float  :
	set(value):
		base_strength = value
		strength = base_strength + extra_strength
	get:
		return base_strength
@export var base_defense : float :
	set(value):
		base_defense = value
		defense = base_defense + extra_defense
@export var base_speed : float :
	set(value):
		base_speed = value
		speed = base_speed + extra_speed

# Battle stats
@export var base_initiative : float :
	set(value):
		base_initiative = value
		initiative = base_initiative + additional_initiative
var additional_initiative : float = 0 :
	set(value):
		additional_initiative = value
		initiative = base_initiative + additional_initiative
var initiative : float 
#@export var action_paths : Array[String]

# Extra stats
var extra_health : float = 0 :
	set(value):
		extra_health = value
		max_health = base_max_health + extra_health
var extra_mana : float = 0:
	set(value):
		extra_mana = value
		max_mana = base_max_mana + extra_mana
var extra_strength : float = 0:
	set(value):
		extra_strength = value
		strength = base_strength + extra_strength
var extra_defense : float = 0:
	set(value):
		extra_defense = value
		defense = base_defense + extra_defense
var extra_speed : float = 0:
	set(value):
		extra_speed = value
		speed = base_speed + extra_speed

func reset():
	health = max_health
	mana = max_mana
