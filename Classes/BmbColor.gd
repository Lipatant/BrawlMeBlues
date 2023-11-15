class_name BmbColor

const player_colors_default : Color = Color(1.0, 1.0, 1.0)
const player_colors : Array[Color] = [
	Color(0.0, 0.0, 1.0),
	Color(1.0, 0.0, 0.0),
	Color(1.0, 1.0, 0.0),
	Color(0.0, 1.0, 0.0),
	Color(1.0, 0.5, 0.0),
	Color(0.0, 1.0, 1.0),
	Color(1.0, 0.0, 1.0),
	Color(1.0, 1.0, 1.0),
]

static func from_player_id(player_id: int, scale : float = 1.0) -> Color:
	if player_id > 0:
		return player_colors[(player_id - 1) % player_colors.size()] * scale
	else:
		return player_colors_default * scale
