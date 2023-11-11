extends Node

# EXPORTS #

@export var input_join  : String = "jump"
@export var input_leave : String = "jump"

# ONREADY #

@onready var _player_joining_container : BoxContainer = $PlayerJoiningContainer
@onready var _resource_player_joining : Resource = preload("res://Scenes/UserInterfaces/PlayerJoiningMenu/PlayerJoiningGradiant.tscn")

# OTHER VARIABLES #

var _players : Dictionary

# PROCESS #

func _ready() -> void:
	_add_player(false)
#	_add_player(true, 0)
#	_add_player(true, 1)
	pass

func _process(_delta: float) -> void:
	for controller_id in BmbGame.controller_list:
		if _is_already_connected(true, controller_id) or !Input.is_action_just_pressed(BmbInput.get_input(input_join, true, controller_id)):
			continue
		print("NEW!")
		print(controller_id)
		_add_player(true, controller_id)

func _is_already_connected(is_using_controller: bool, controller_id: int = 0) -> bool:
	if is_using_controller:
		for player_id in _players:
			if _players[player_id]["is_using_controller"] and _players[player_id]["controller_id"] == controller_id:
				return true
	else:
		for player_id in _players:
			if !_players[player_id]["is_using_controller"]:
				return true
	return false

# ADD PLAYER #

func _add_player(is_using_controller: bool, controller_id: int = 0, player_id: int = 0) -> bool:
	if player_id > 0:
		if _players.has(player_id):
			return false
	else:
		player_id += 1
		while _players.has(player_id):
			player_id += 1
	_players[player_id] = {
		"is_using_controller" = is_using_controller,
		"controller_id" = controller_id,
		"player_joining" = _add_player_joining(is_using_controller, controller_id, player_id)
	}
	return true

func _add_player_joining(is_using_controller: bool, controller_id: int = 0, player_id: int = 0) -> PlayerJoiningGradiant:
	if !_player_joining_container or !_resource_player_joining:
		return null
	var player_joining : PlayerJoiningGradiant = _resource_player_joining.instantiate()
	if !player_joining:
		return null
	player_joining.set_player(player_id)
	player_joining.set_controller(is_using_controller, controller_id)
	_player_joining_container.add_child(player_joining)
	return player_joining
