extends Control

var fighters : Array[Fighter] = [] :
	set(value):
		allies = []
		enemies = []
		for f in fighters:
			if f is AllyFighter:
				allies.append(f)
			elif f is EnemyFighter:
				enemies.append(f)
var allies : Array[AllyFighter] = []
var enemies : Array[EnemyFighter] = []
