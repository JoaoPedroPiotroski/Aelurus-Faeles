extends Component

@export var gravity : float = 8.0

func _physics_process(_delta: float) -> void:
	parent.velocity.y += gravity 
