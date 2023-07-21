class_name BattleController
extends Control

signal intro_start
signal intro_end
## Allies appear into the field
signal ally_enter
## Enemies apear into the field
signal enemy_enter
## A number is rolled for each Fighter and their initiative is settled
signal dice_roll 
## The turn order is settled and displayed
signal turn_settle 
signal battle_start
signal battle_end
signal round_start
signal round_end
signal turn_start(Fighter)
signal turn_end(Fighter)
signal option_select
signal action_select
signal action_start
signal action_use
signal action_end

enum TARGETS {
	ALLY,
	ENEMY,
	SELF
}

var started : bool = false
## The one calling the action
var agitator : Fighter 
## The target of the action
var target : Fighter 
## Current executed action
var action : BattleAction
## Order at which turns will be called
var turn_order : Array[Fighter] = [] 
## The allies to participate in the battle
var ally_participants : Array[Fighter] = []
## The enemies to participate in the battle
var enemy_participants : Array[Fighter] = []
## Current round
var round : int = 0
## Current turn
var turn : int = 0
## Amount of pixels to be vertically offset for each fighter
var v_offset = 5

@onready var allies_box: HBoxContainer = $Allies/AlliesBox
@onready var enemies_box: HBoxContainer = $Enemies/EnemiesBox

func start(s_ally_participants : Array[Fighter], s_enemy_participants : Array[Fighter]):
	ally_participants = s_ally_participants
	enemy_participants = s_enemy_participants
	s_enemy_participants.reverse()
	var counter : int = 0
	for participant in s_ally_participants:
		allies_box.add_child(participant)
		counter += 1
	for participant in s_enemy_participants:
		counter -= 1
	emit_signal("intro_start")

func _ready() -> void:
	pass

## For the time being does nothing but call for allies to enter
func _on_intro_started(): 
	emit_signal("ally_enter")
	
func _on_ally_entered():
	emit_signal("enemy_enter") 

func _on_enemy_entered():
	emit_signal("dice_roll")

func _on_dice_rolled():
	emit_signal("turn_settle")

func _on_intro_ended():
	emit_signal("battle_start")
	emit_signal("round_start")

## Selects first fighter in [member turn_order] and calls [signal turn_start] and passes them as parameter
func _on_round_started(): 
	turn = 0
	agitator = turn_order[turn]
	emit_signal("turn_start", agitator)

## Starts next round resetting [member turn] to 0
func _on_round_ended(): 
	emit_signal("round_start")
	
func _on_turn_started(agitator : Fighter):
	pass

## Raises [member turn] by 1
func _on_turn_ended(agitator : Fighter): 
	pass
