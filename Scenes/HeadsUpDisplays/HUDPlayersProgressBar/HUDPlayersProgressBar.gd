extends HUD
class_name HUDPlayersProgressBar

# EXPORTS #

## Range used for displaying the current best score
@export var _range : Range

# OTHER VARIABLES #

var _current_percent : float = 0.0

# RECEIVE DATA #

func _receive_data(data) -> void:
	if !(data is DataScoring) or !_range or data.maximum == 0.0:
		return
	var best_score : float = data.minimum
	for player_id in data.players:
		if best_score < data.players[player_id]:
			best_score = data.players[player_id]
	var best_score_percent : float = (best_score - data.minimum) / data.maximum
	if _current_percent != best_score_percent:
		_range.value = best_score_percent
		_current_percent = best_score_percent
