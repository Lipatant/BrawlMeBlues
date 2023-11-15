extends HUD
class_name HUDPlayersProgressBarCursor

# EXPORTS #

## Node possessing a 'color' member to change
@export var colored : Node
## Key of the member to change
@export var colored_member : String = "color"
## Node to move alongside the score
@export var cursor : Control

# OTHER VARIABLES #

var _player_id : int = -1
var _current_percent : float = 0.0

# SEND DIRECT DATA #

func send_progress_percent(new_percent: float) -> void:
	if new_percent != _current_percent and cursor:
		cursor.anchor_left = new_percent
		cursor.anchor_right = new_percent

func set_player_id(player_id: int):
	if player_id != _player_id and colored and colored_member in colored:
		colored[colored_member] = BmbColor.from_player_id(player_id, 0.8)
		_player_id = player_id
