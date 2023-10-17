class_name PartyMember
extends AllyFighter

var friction := 0.98

enum states {
	STARTING,
	STOPPED,
	GOING,
	STOPPING
}
var stopping = false
var state = states.STARTING

var id : int = 0
var target_position : 
	set(value):
		old_target_position = target_position
		target_position = value
		trajectory_id = 0
		if old_target_position:
			max_trajectory_id = old_target_position.trajectory.size()-1
var old_target_position
var target_pos := Vector2.ZERO
var trajectory_id : int = 0
var max_trajectory_id : int = 0

func _physics_process(delta):
	pass

func add_to_party():
	if PartyController.party.size() < 4:
		PartyController.party.append(self)

func remove_from_party():
	PartyController.party.erase(self)
