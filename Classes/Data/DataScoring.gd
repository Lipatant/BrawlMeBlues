class_name DataScoring

# VARIABLES #

var minimum : float
var maximum : float

var players : Dictionary

func _init(initial_minimum: float = 0.0, initial_maximum: float = 1.0):
	minimum = initial_minimum
	maximum = initial_maximum

func set_player_score(player_id: int, value: float) -> void:
	players[player_id] = value

func add_player_score(player_id: int, value: float) -> void:
	if players.has(player_id):
		players[player_id] += value
	else:
		players[player_id] = minimum + value

func get_player_score(player_id: int) -> float:
	return players[player_id] if players.has(player_id) else minimum
