extends ColorRect
class_name PlayerJoiningGradiant

# EXPORTS #

@export var default_player_id : int = 0
@export var default_is_using_controller : bool = false

# ONREADIES #

@onready var _controller_controller : CanvasItem = $Controller/Controller
@onready var _controller_keyboard : CanvasItem = $Controller/Keyboard
@onready var _controller_name : Label = $ControllerName
@onready var _player_name : Label = $PlayerName

# READY #

func _ready() -> void:
	if default_player_id > 0:
		set_player(default_player_id)
	if default_is_using_controller:
		set_controller(default_is_using_controller)

# PLAYER #

func set_player(player_id : int) -> void:
	if !_player_name:
		default_player_id = player_id
	else:
		color = BmbColor.from_player_id(player_id, 0.5)
		_player_name.text = "Player " + str(player_id)

func set_controller(is_using_controller: bool, _controller_id: int = 0) -> void:
	if !_controller_controller or !_controller_keyboard or !_controller_name:
		default_is_using_controller = is_using_controller
	else:
		if is_using_controller:
			_controller_controller.visible = true
			_controller_keyboard.visible = false
			_controller_name.text = Input.get_joy_name(_controller_id)
		else:
			_controller_controller.visible = false
			_controller_keyboard.visible = true
			_controller_name.text = ""
