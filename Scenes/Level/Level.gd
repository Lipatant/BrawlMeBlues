extends Node2D
class_name Level

# ONREADIES #

@onready var _player_entity_resource : Resource = preload("res://Entities/Player.tscn")
@onready var _player_spawn_point : Node2D = $PlayerSpawnPoint

# OTHER VARIABLES #

var scene_manager : SceneManager

var _players : Dictionary
var _players_waiting : Array[int]

# PROCESS #

func _process(delta: float) -> void:
	if !_players_waiting.is_empty():
		for player_id in _players_waiting:
			if _players.has(player_id):
				_players[player_id]["player_entity"] = _add_player_entity(_players[player_id]["is_using_controller"], _players[player_id]["controller_id"], player_id)
		_players_waiting = []
	for player_id in _players:
		if !_players[player_id].has("player_entity") or !_players[player_id]["player_entity"]:
			continue
		if !_players[player_id].has("current_score"):
			_players[player_id]["current_score"] = 0.0
		_on_player_held(delta, player_id, _players[player_id]["player_entity"].held_item)

func _on_player_held(delta: float, player_id: int, held_item: Item) -> void:
	if !held_item:
		return
	if held_item is Mustache:
		_players[player_id]["current_score"] += delta
		print(player_id, " ", _players[player_id]["current_score"])

func _physics_process(_delta: float) -> void:
	for player_id in _players:
		if !_players[player_id]["player_entity"] or _players[player_id]["player_entity"].progress < _players[player_id]["player_entity"].progress_max:
			continue
		if scene_manager:
			scene_manager.load_main_menu()
		break

# PLAYERS #

func add_player(is_using_controller: bool, controller_id: int = 0, player_id: int = 0) -> bool:
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
		"player_entity" = _add_player_entity(is_using_controller, controller_id, player_id)
	}
	return true

func _add_player_entity(is_using_controller: bool, controller_id: int = 0, player_id: int = 0) -> Player:
	if !_player_entity_resource or !_player_spawn_point:
		if !_players_waiting.has(player_id):
			_players_waiting.append(player_id)
		return null
	var player_entity : Player = _player_entity_resource.instantiate()
	if !player_entity:
		return null
	player_entity.player_id = player_id
	player_entity.is_using_controller = is_using_controller
	player_entity.controller_id = controller_id
	_player_spawn_point.add_child(player_entity)
	return player_entity
