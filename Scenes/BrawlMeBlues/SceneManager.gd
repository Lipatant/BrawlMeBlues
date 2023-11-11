extends Node
class_name SceneManager

# ONREADIES #

@onready var _main_menu_resource : Resource = preload("res://Scenes/UserInterfaces/MainMenu.tscn")
@onready var _player_joining_menu_resource : Resource = preload("res://Scenes/UserInterfaces/PlayerJoiningMenu.tscn")
@onready var _level_resource : Resource = preload("res://Scenes/Level.tscn")

# OTHER VARIABLES #

var _current_scene : CanvasItem
var _players : Dictionary

# READY #

func _ready() -> void:
	load_main_menu()

# LOAD SCENES #

func _load_scene(resource: Resource) -> CanvasItem:
	if _current_scene:
		_current_scene.queue_free()
	_current_scene = resource.instantiate()
	if _current_scene:
		add_child(_current_scene)
		if "scene_manager" in _current_scene:
			_current_scene["scene_manager"] = self
	return _current_scene

func load_level() -> void:
	var level : Level = _load_scene(_level_resource)
	if !level:
		return
	for player_id in _players:
		level.add_player(_players[player_id]["is_using_controller"], _players[player_id]["controller_id"], player_id)

func load_main_menu() -> void:
	_load_scene(_main_menu_resource)

func load_player_joining_menu() -> void:
	_load_scene(_player_joining_menu_resource)

# GET DATA #

func set_players(players: Dictionary = {}):
	print(players)
	_players = players
