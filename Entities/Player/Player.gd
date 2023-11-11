extends Entity
class_name Player

# EXPORTS #

@export var input_up    : String = "up"
@export var input_down  : String = "down"
@export var input_left  : String = "left"
@export var input_right : String = "right"
@export var input_jump  : String = "jump"

# ONREADIES #

# OTHER VARIABLES #

# CONSTANTS #

# MOVEMENT #

func _entity_movement() -> Vector2:
	if Input.is_action_just_pressed(input_jump):
		_entity_jump()
	var local_movement : float = Input.get_action_strength(input_right) - Input.get_action_strength(input_left)
	return Vector2(local_movement, 0.0)

func is_wall_sliding(only: bool = false) -> bool:
	return super.is_wall_sliding(only) and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
