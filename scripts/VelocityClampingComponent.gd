extends Component

@export var max_speed := Vector2.ZERO

func _physics_process(_delta: float) -> void:
	parent.velocity.x = clamp(parent.velocity.x, -max_speed.x, max_speed.x)
	parent.velocity.y = clamp(parent.velocity.y, -max_speed.y, max_speed.y)
	
