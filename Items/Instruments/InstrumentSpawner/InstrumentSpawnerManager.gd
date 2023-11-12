extends Node2D
class_name InstrumentSpawnerManager

# OTHER VARIABLES #

var _number_generator : RandomNumberGenerator = RandomNumberGenerator.new()
var _spawners : Array[Node] = []

# ONREADIES #

func _ready() -> void:
	for child in get_children():
		if child is InstrumentSpawner:
			_spawners.append(child)
			child.number_generator = _number_generator
			child.start_spawn_item_timer()
