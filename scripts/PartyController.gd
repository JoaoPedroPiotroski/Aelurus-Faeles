class_name PartyController
extends Node2D

static var party : Array[PartyMember]:
	set(value):
		party = value
		for member in party:
			member.id = party.find(member)
			
static var target_positions : Array[target_position]

var last_standing_target : target_position
var last_player_position : Vector2 = Vector2.ZERO
@export var max_queue_size : int = 100
@export var min_valid_standing_distance : float = 15.0

class target_position:
	var standing_pos : Vector2
	var owner : int = 0
	var stand : bool = false
	var trajectory : Array[Vector2]
	func _init(p_pos : Vector2, p_stand : bool = false):
		self.standing_pos = p_pos
		self.stand = p_stand
	func add_point(p : Vector2):
		trajectory.append(p)
		
func _ready():
	var player : AllyFighter = get_parent()
	var new_target_pos = target_position.new(player.global_position)
	PartyController.target_positions.push_back(new_target_pos)
	
func is_far_away() -> bool:
	var player = get_parent()
	var value = true
	for t in target_positions:
		if t.standing_pos.distance_to(player.global_position) < min_valid_standing_distance:
			value = false
	return value

func update_player_position_queue() -> void:
	var player : AllyFighter = get_parent()
	#print(target_positions)
	# if player is moving
	if player.global_position != last_player_position:
		# if it's a standing position
		if is_far_away():
			var new_target_pos = target_position.new(player.global_position)
			for target in target_positions:
				target.owner += 1
				if target.owner > party.size() + 1:
					target_positions.erase(target)
			PartyController.target_positions.push_back(new_target_pos)
		else:
			if target_positions.size() > 0:
				target_positions.back().trajectory.append(player.global_position)
	queue_redraw()

#func _draw():
#	for t in target_positions:
#		draw_circle(to_local(t.standing_pos), 5, Color.RED)
#		for p in t.trajectory:
#			draw_circle(to_local(p), 1, Color.GREEN)

func _on_timer_timeout():
	update_player_position_queue()
