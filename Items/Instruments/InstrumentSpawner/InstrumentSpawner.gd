extends Node2D
class_name InstrumentSpawner

# EXPORT #

var number_generator : RandomNumberGenerator

# ONREADIES #

@onready var _items : Array[Resource] = [
	preload("res://Items/Instruments/Clarinet.tscn"),
	preload("res://Items/Instruments/Trumpet.tscn"),
]
@onready var _timer : Timer = $Timer

# OTHER VARIABLES #

var _item : WeakRef

# READY #

func _ready() -> void:
	if number_generator:
		number_generator = RandomNumberGenerator.new()

func _physics_process(_delta: float) -> void:
	if (_item and _item.get_ref()) or !_timer or !_timer.is_stopped():
		return
	start_spawn_item_timer()

func _on_timer_timeout():
	spawn_item()

# SPAWN ITEM #

func start_spawn_item_timer() -> bool:
	if (_item and _item.get_ref()) or !_timer or !_timer.is_stopped():
		return false
	_item = null
	if number_generator:
		_timer.set_wait_time(5.0 * (0.5 + number_generator.randf() / 2))
	_timer.start()
	return true

func spawn_item() -> bool:
	if _item and _item.get_ref():
		return false
	_item = null
	if number_generator:
		_spawn_item_from_resource(_items[number_generator.randi() % _items.size()])
	else:
		_spawn_item_from_resource(_items[0])
	return true

func _spawn_item_from_resource(resource: Resource) -> Item:
	if !resource:
		return null
	var item : Node2D = resource.instantiate()
	if item:
		get_tree().current_scene.add_child(item)
		item.global_position = global_position
	_item = weakref(item)
	return item
