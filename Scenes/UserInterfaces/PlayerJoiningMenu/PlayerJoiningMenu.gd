extends Node

# EXPORTS #

@export var input_join  : String = "jump"
@export var input_leave : String = "drop"

# ONREADY #

@onready var _player_joining_container : Control = $PlayerJoiningContainer
@onready var _starting_bar : Range = $StartingBar
@onready var _starting_timer : Timer = $StartingTimer

@onready var _resource_player_joining : Resource = preload("res://Scenes/UserInterfaces/PlayerJoiningMenu/PlayerJoiningGradiant.tscn")

# OTHER VARIABLES #

var scene_manager : SceneManager

var _players : Dictionary

# PROCESS #

func _process(_delta: float) -> void:
	for controller_id in BmbGame.controller_list:
		if _is_already_connected(true, controller_id):
			if Input.is_action_just_pressed(BmbInput.get_input(input_leave, true, controller_id)):
				_remove_player(true, controller_id)
		else:
			if Input.is_action_just_pressed(BmbInput.get_input(input_join, true, controller_id)):
				_add_player(true, controller_id)
	if !_is_already_connected(false) and Input.is_action_just_pressed(BmbInput.get_input(input_join, false)):
		_add_player(false)
	if _players.size() >= BmbGame.player_count_min:
		if _starting_timer.is_stopped():
			_starting_timer.start()
	else:
		if !_starting_timer.is_stopped():
			_starting_timer.stop()
	if _starting_timer.is_stopped():
		_starting_bar.set_value_no_signal(1.0)
	else:
		_starting_bar.set_value_no_signal(_starting_timer.time_left / _starting_timer.wait_time)

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

# GAME TIMER #

func _on_starting_timer_timeout() -> void:
	if scene_manager:
		scene_manager.set_players(_players)
		scene_manager.load_level()

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
	if _starting_timer:
		_starting_timer.stop()
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

func _remove_player(is_using_controller: bool, controller_id: int = 0) -> void:
	if is_using_controller:
		for player_id in _players:
			if _players[player_id]["is_using_controller"] and _players[player_id]["controller_id"] == controller_id:
				if _players[player_id]["player_joining"]:
					_players[player_id]["player_joining"].queue_free()
				_players.erase(player_id)
	else:
		for player_id in _players:
			if !_players[player_id]["is_using_controller"]:
				if _players[player_id]["player_joining"]:
					_players[player_id]["player_joining"].queue_free()
				_players.erase(player_id)
	if _starting_timer:
		_starting_timer.stop()
