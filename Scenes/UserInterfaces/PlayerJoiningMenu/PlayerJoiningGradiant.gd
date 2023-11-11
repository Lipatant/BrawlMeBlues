extends ColorRect
class_name PlayerJoiningGradiant

# EXPORTS #

@export var default_player_id : int = 0
@export var default_is_using_controller : bool = false

# ONREADIES #

@onready var _controller_controller : CanvasItem = $Controller/Controller
@onready var _controller_keyboard : CanvasItem = $Controller/Keyboard

# READY #

func _ready() -> void:
	if default_player_id > 0:
		set_player(default_player_id)
	if default_is_using_controller:
		set_controller(default_is_using_controller)

# PLAYER #

func set_player(player_id : int, scale : float = 1.0, scale_alpha : bool = true) -> void:
	color = BmbColor.from_player_id(player_id, 0.8) * scale

func set_controller(is_using_controller: bool, _controller_id: int = 0) -> void:
	if is_using_controller:
		_controller_controller.visible = true
		_controller_keyboard.visible = false
	else:
		_controller_controller.visible = false
		_controller_keyboard.visible = true
