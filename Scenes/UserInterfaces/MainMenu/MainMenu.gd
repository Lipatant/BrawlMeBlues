extends Control

# ONREADIES #

@onready var _buttons : Dictionary = {
	"NewGame": $ButtonsContainer/NewGame,
	"Seggins": $ButtonsContainer/Settings,
	"Leave"  : $ButtonsContainer/Leave
}

# READY #

func _ready() -> void:
	_buttons["NewGame"].grab_focus()

# SIGNALS #

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Scenes/UserInterfaces/PlayerJoiningMenu.tscn")

func _on_leave_pressed():
	pass # Replace with function body.
	get_tree().quit()
