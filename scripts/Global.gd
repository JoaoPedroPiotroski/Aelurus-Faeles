extends Node

var in_battle : bool = false
var average_fighter_positions : Vector2 : 
	get:
		var sum1 = Vector2.ZERO
		var sum2 = Vector2.ZERO
		for f in party:
			sum1 += f.global_position
		for f in enemies:
			sum2 += f.global_position
		sum1 = sum1/party.size()
		sum2 = sum2/enemies.size()
		return (sum1 + sum2) / 2

var party : Array[AllyFighter]
var enemies : Array[EnemyFighter]
var player : AllyFighter

signal battle_ended

func start_battle(battle_enemies : Array):
	in_battle = true
	var enemy_avg_pos : Vector2
	var enemy_pos_sum : Vector2 = Vector2.ZERO
	var enemy_quantity = 0
	for e in battle_enemies:
		e.prepare_for_battle()
		enemies.append(e)
		enemy_pos_sum += e.global_position
		enemy_quantity += 1
	enemy_avg_pos = enemy_pos_sum / enemy_quantity
	
	var ally_avg_pos : Vector2
	var ally_pos_sum : Vector2 = Vector2.ZERO
	var ally_quantity = 0
	for a in party:
		a.prepare_for_battle()
		ally_pos_sum += a.global_position
		ally_quantity += 1
	ally_avg_pos = ally_pos_sum / ally_quantity
	
	var overall_avg : Vector2 = (ally_avg_pos + enemy_avg_pos) / 2
	
	var pos_helper := Node2D.new()
	var angle_helper := Node2D.new()
	pos_helper.add_child(angle_helper)
	angle_helper.position = Vector2(10, 0)
	get_tree().root.add_child(pos_helper)
	
	var enemy_possible_positions : Array[Vector2]
#	for i in range(16): #enemy position finder
#		var target_dir := pos_helper.global_position.direction_to(angle_helper.global_position)
#		var target_pos := enemy_avg_pos + (target_dir * 80)
#		var space_state = pos_helper.get_world_2d().direct_space_state
#		var query = PhysicsRayQueryParameters2D.create(enemy_avg_pos, target_pos)
#		var result = space_state.intersect_ray(query)
#		pos_helper.rotation = deg_to_rad(float(i) * (360.0 / 16.0))
#		print("resultado "+str(i )+":", result)
#		if result:
#			print("resultado "+str(i )+": verdadeiro")
#			enemy_possible_positions.append(result.position)
#		else:
#			enemy_possible_positions.append(target_pos)
#	print('desorganizado ', enemy_possible_positions)
#	var sorted = false
#	while not sorted:
#		var swapped = false
#		for i in enemy_possible_positions.size():
#			if enemy_possible_positions[i].distance_squared_to(ally_avg_pos) > enemy_possible_positions[min(i+1, enemy_possible_positions.size()-1)].distance_squared_to(ally_avg_pos):
#				var b = enemy_possible_positions[i]
#				enemy_possible_positions[i] = enemy_possible_positions[i+1]
#				enemy_possible_positions[i+1] = b
#				swapped = true
#		sorted = not swapped
#	print('organizado: ', enemy_possible_positions)
#	var already_found_positions : Array[Vector2]
#	for e in battle_enemies:
#		for p_position in enemy_possible_positions:
#			var too_close = false
#			for a_f in already_found_positions:
#				if p_position.distance_to(a_f) < 24.0:
#					too_close = true
#			if not too_close:
#				e.battle_target_pos = p_position
#				already_found_positions.append(p_position)
#				enemy_possible_positions.erase(p_position)
#		print('rodei')
#		#e.battle_target_pos = enemy_possible_positions[e_id]
	
#	var ally_possible_positions : Array[Vector2]
#	for i in range(16): #ally position finder
#		var target_dir := pos_helper.global_position.direction_to(angle_helper.global_position)
#		var target_pos := ally_avg_pos + (target_dir * 80)
#		var space_state = pos_helper.get_world_2d().direct_space_state
#		var query = PhysicsRayQueryParameters2D.create(ally_avg_pos, target_pos)
#		var result = space_state.intersect_ray(query)
#		pos_helper.rotation = deg_to_rad(float(i) * (360.0 / 16.0))
#		if result:
#			ally_possible_positions.append(result.position)
#		else:
#			ally_possible_positions.append(target_pos)
#	sorted = false
#	while not sorted:
#		var swapped = false
#		for i in ally_possible_positions.size():
#			if ally_possible_positions[i].distance_squared_to(enemy_avg_pos) > ally_possible_positions[min(i+1, ally_possible_positions.size()-1)].distance_squared_to(enemy_avg_pos):
#				var b = ally_possible_positions[i]
#				ally_possible_positions[i] = ally_possible_positions[i+1]
#				ally_possible_positions[i+1] = b
#				swapped = true
#		sorted = not swapped
#	print('organizado: ', enemy_possible_positions)
#	already_found_positions = []
#	for a in party:
#		for p_position in ally_possible_positions:
#			var too_close = false
#			for a_f in already_found_positions:
#				if p_position.distance_to(a_f) < 24.0:
#					too_close = true
#			if not too_close:
#				a.battle_target_pos = p_position
#				already_found_positions.append(p_position)
#				ally_possible_positions.erase(p_position)
	pos_helper.queue_free()
	average_fighter_positions = (ally_avg_pos + enemy_avg_pos) / 2
	
	for fighter in party + battle_enemies:
		var notif = VisibleOnScreenNotifier2D.new()
		battle_ended.connect(notif.queue_free)
		notif.rect = Rect2(Vector2(-1, -1), Vector2(2, 2))
		fighter.add_child(notif)
	BattleController.start_battle()
	
func add_battle_controller():
	pass
