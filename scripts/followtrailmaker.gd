extends Component
class_name TrailMaker

@export_node_path("CharacterBody2D") var trailmaker_np : NodePath
@export_node_path("RayCast2D") var ground_detector_np : NodePath
@export var min_point_distance : float
@export var max_trail_size : float

var trail : Array[TrailPoint]
var trailmaker : CharacterBody2D
var ground_detector : RayCast2D
var last_trailmaker_pos : Vector2
var last_tpoint : TrailPoint

class TrailPoint:
	var position : Vector2 = Vector2.ZERO
	var standable : bool = false
	var velocity : Vector2 = Vector2.ZERO
	func _init(p_position : Vector2 = Vector2.ZERO, p_standable : bool = false, p_velocity : Vector2 = Vector2.ZERO):
		self.position = p_position
		self.standable = p_standable
		self.velocity = p_velocity

func _ready():
	trailmaker = get_node(trailmaker_np)
	ground_detector = get_node(ground_detector_np)

func _physics_process(delta):
	var far_enough := false
	if last_trailmaker_pos != trailmaker.global_position:
		if last_tpoint:
			if last_tpoint.position.distance_to(trailmaker.global_position) > min_point_distance or (not last_tpoint.standable and ground_detector.is_colliding()):
				far_enough = true
		else:
			far_enough = true
		if ground_detector.is_colliding():
			var tpoint = TrailPoint.new(trailmaker.global_position, true, trailmaker.velocity)
			if far_enough:
				trail.append(tpoint)
				last_tpoint = tpoint
		else:
			var tpoint = TrailPoint.new(trailmaker.global_position, false, trailmaker.velocity)
			if far_enough:
				trail.append(tpoint)
				last_tpoint = tpoint
				
	if trail.size() > 100:
		trail.pop_front()
	last_trailmaker_pos = trailmaker.global_position
