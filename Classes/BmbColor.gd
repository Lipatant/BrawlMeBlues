class_name BmbColor

const player_colors : Array[Color] = [
	Color(1.0, 1.0, 1.0),
	Color(0.0, 0.0, 1.0),
	Color(1.0, 0.0, 0.0),
	Color(0.0, 1.0, 0.0),
	Color(1.0, 1.0, 0.0),
]

static func from_player_id(player_id: int, scale : float = 1.0) -> Color:
	return player_colors[player_id % player_colors.size()] * scale
