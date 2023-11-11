extends Entity
class_name Player

# EXPORTS #

@export var player_id           : int  = 0
@export var is_using_controller : bool = false
@export var controller_id       : int  = 0

@export var input_up    : String = "up"
@export var input_down  : String = "down"
@export var input_left  : String = "left"
@export var input_right : String = "right"
@export var input_jump  : String = "jump"

# ONREADIES #

@onready var _sprite : Node2D = $Sprite

# OTHER VARIABLES #

# CONSTANTS #

# MOVEMENT #

func _entity_movement() -> Vector2:
	if Input.is_action_just_pressed(input_jump):
		_entity_jump()
	var local_movement : float = Input.get_action_strength(input_right) - Input.get_action_strength(input_left)
	if local_movement != 0.0:
		for child in _sprite.get_children(): if child is Sprite2D:
			child.frame_coords.y = 0 if local_movement > 0.0 else 1
	return Vector2(local_movement, 0.0)

func is_wall_sliding(only: bool = false) -> bool:
	return super.is_wall_sliding(only) and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
