class_name BattleController
extends Control

var fighters : Array[Fighter] = []

enum TARGETS {
	ALLY,
	ENEMY,
	SELF
}

func start_battle(_p_enemy_fighters : Array[EnemyFighter]):
	pass
