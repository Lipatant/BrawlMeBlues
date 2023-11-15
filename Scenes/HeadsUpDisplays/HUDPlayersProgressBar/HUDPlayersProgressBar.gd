extends HUD
class_name HUDPlayersProgressBar

# EXPORTS #

## Parent node for cursors
@export var _cursor_parent : Node
## Range used for displaying the current best score
@export var _range : Range

# ONREADIES #

@onready var _cursor_resource : Resource = preload("res://Scenes/HeadsUpDisplays/HUDPlayersProgressBar/HUDPlayersProgressBarCursor.tscn")

# OTHER VARIABLES #

var _cursors : Dictionary
var _current_percent : float = 0.0

# RECEIVE DATA #

func _receive_data(data) -> void:
	if !(data is DataScoring) or !_range or data.maximum == 0.0:
		return
	var player_score : float
	var player_score_percent : float
	var best_score : float = data.minimum
	var best_score_percent : float = 0.0
	for player_id in data.players:
		player_score = data.get_player_score(player_id)
		player_score_percent = (player_score - data.minimum) / data.maximum
		if player_score_percent < 0.0:
			player_score_percent = 0.0
		elif player_score_percent > 1.0:
			player_score_percent = 1.0
		if best_score < player_score:
			best_score = player_score
		if best_score_percent < player_score_percent:
			best_score_percent = player_score_percent
		if (!_cursors.has(player_id) or !_cursors[player_id]) and _cursor_parent:
			_cursors[player_id] = _cursor_resource.instantiate()
			if !_cursors[player_id]:
				continue
			_cursors[player_id].set_player_id(player_id)
			_cursor_parent.add_child(_cursors[player_id])
		if _cursors.has(player_id) and _cursors[player_id]:
			_cursors[player_id].send_progress_percent(player_score_percent)
	if _current_percent != best_score_percent:
		_range.value = best_score_percent
		_current_percent = best_score_percent
