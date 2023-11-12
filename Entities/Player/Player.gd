extends Entity
class_name Player

# EXPORTS #

@export var player_id           : int  = 0
@export var is_using_controller : bool = false
@export var controller_id       : int  = 0

@export var input_up           : String = "up"
@export var input_down         : String = "down"
@export var input_left         : String = "left"
@export var input_right        : String = "right"
@export var input_jump         : String = "jump"
@export var input_item_use     : String = "attack"
@export var input_item_drop    : String = "drop"
#@export var input_item_special : String = "attack"

# ONREADIES #

@onready var _trail : CPUParticles2D = $Trail

# OTHER VARIABLES #

var _current_player_rotation : Vector2

# READY #

func _ready() -> void:
	super._ready()
	if _trail:
		_trail.color = BmbColor.from_player_id(player_id)

# MOVEMENT #

func _entity_movement() -> Vector2:
	if Input.is_action_just_pressed(BmbInput.get_input(input_jump, is_using_controller, controller_id)):
		_entity_jump()
	if Input.is_action_pressed(BmbInput.get_input(input_item_use, is_using_controller, controller_id)):
		item_use()
	if Input.is_action_just_pressed(BmbInput.get_input(input_item_drop, is_using_controller, controller_id)):
		item_drop()
	if (Input.get_action_strength(BmbInput.get_input(input_right, is_using_controller, controller_id)) - Input.get_action_strength(BmbInput.get_input(input_left, is_using_controller, controller_id))) != 0.0 or (Input.get_action_strength(BmbInput.get_input(input_down, is_using_controller, controller_id)) - Input.get_action_strength(BmbInput.get_input(input_up, is_using_controller, controller_id))) != 0.0:
		_current_player_rotation = Vector2(Input.get_action_strength(BmbInput.get_input(input_right, is_using_controller, controller_id)) - Input.get_action_strength(BmbInput.get_input(input_left, is_using_controller, controller_id)), Input.get_action_strength(BmbInput.get_input(input_down, is_using_controller, controller_id)) - Input.get_action_strength(BmbInput.get_input(input_up, is_using_controller, controller_id)))
	var local_movement : float = Input.get_action_strength(BmbInput.get_input(input_right, is_using_controller, controller_id)) - Input.get_action_strength(BmbInput.get_input(input_left, is_using_controller, controller_id))
	if local_movement != 0.0:
		for child in _sprite.get_children(): if child is Sprite2D:
			child.frame_coords.y = 0 if local_movement > 0.0 else 1
	return Vector2(local_movement, 0.0)

func is_wall_sliding(only: bool = false) -> bool:
	return super.is_wall_sliding(only) and (Input.get_action_strength(BmbInput.get_input(input_left, is_using_controller, controller_id)) or Input.get_action_strength(BmbInput.get_input(input_right, is_using_controller, controller_id)))

func get_entity_rotation() -> Vector2:
	return _current_player_rotation
