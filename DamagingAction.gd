extends BattleAction
class_name DamagingAction

@export var attack_power : float = 1.

func _on_target_selected(target : Fighter):
	target.stats.health -= governor.stats.strength * attack_power / (target.stats.defense / 2.)
