extends Control

# ONREADIES #

@onready var _buttons : Dictionary = {
	"NewGame": $ButtonsContainer/NewGame,
	"Seggins": $ButtonsContainer/Settings,
	"Leave"  : $ButtonsContainer/Leave
}

# OTHER VARIABLES #

var scene_manager : SceneManager

# READY #

func _ready() -> void:
	_buttons["NewGame"].grab_focus()

# SIGNALS #

func _on_new_game_pressed():
	if scene_manager:
		scene_manager.load_player_joining_menu()

func _on_leave_pressed():
	get_tree().quit()
