extends CharacterBody2D
class_name Entity

# EXPORTS #

@export var speed : float = 10000.0
@export var jump_force : float = 60000.0
@export var jump_count : int = 2

# OTHER VARIABLES #

var _motions : Array[Dictionary] = []
var _jumps : int = 0
var _since_floor : float = 0.0

# CONSTS #

const BASE_GRAVITY : float = 16000.0

# PROCESS #

func _physics_process(delta: float) -> void:
	velocity.x = 0
	if _since_floor >= 1.0:
		velocity.y = _get_gravity()
	elif _since_floor > 0.0:
		velocity.y = _get_gravity() * (0.5 + _since_floor / 2)
	if is_on_wall():
		_remove_motion_from_id("jump")
		velocity.y /= 5
	velocity += _entity_movement() * speed
	velocity += _process_motion(delta)
	velocity *= delta
	move_and_slide()
	if is_on_ceiling():
		_remove_motion_from_id("jump")
	if is_on_floor():
		_since_floor = 0
		_jumps = jump_count
	else:
		_since_floor += delta
	if is_on_wall():
		_jumps = 1 if jump_count >= 1 else jump_count
		if _since_floor > 0.2:
			_since_floor = 0.2

func _entity_movement() -> Vector2:
	return Vector2(0, 0)

# GET CONSTANTS #

static func _get_gravity() -> float:
	return BASE_GRAVITY

# MOTIONS #

func add_motion(data: Dictionary) -> void:
	if data.has("id"):
		_remove_motion_from_id(data["id"])
	_motions.append(data)

func _process_motion(delta: float = 0.0) -> Vector2:
	var motion_vector : Vector2 = Vector2(0, 0)
	var motion_id : int = 0
	var motion_size : int = _motions.size()
	while motion_id < motion_size:
		if !_has_motion_key(motion_id, "motion"):
			motion_id += 1
			continue
		if _has_motion_key(motion_id, "duration"):
			_set_motion_key(motion_id, "duration_max", _get_motion_key(motion_id, "duration"), false)
			if _get_motion_key(motion_id, "duration_max", 0.0) > 0.0 or _get_motion_key(motion_id, "decreasing"):
				motion_vector += _get_motion_key(motion_id, "motion", Vector2(0, 0)) \
					* (_get_motion_key(motion_id, "duration") / _get_motion_key(motion_id, "duration_max", 1.0))
			else:
				motion_vector += _get_motion_key(motion_id, "motion", Vector2(0, 0))
			_add_to_motion_key(motion_id, "duration", -delta)
			if _get_motion_key(motion_id, "duration") < 0.0:
				_motions.pop_at(motion_id)
				motion_size -= 1
				continue
		else:
			motion_vector += _get_motion_key(motion_id, "motion", Vector2(0, 0))
		motion_id += 1
	return motion_vector

func _get_motion_key(id: int, key: String, default_value = false):
	if !_has_motion_key(id, key):
		return default_value
	return _motions[id][key]

func _has_motion_key(id: int, key: String, default_value: bool = false) -> bool:
	if id >= _motions.size():
		return default_value
	return _motions[id].has(key)

func _set_motion_key(id: int, key: String, value, can_overwrite: bool = true) -> void:
	if id >= _motions.size() and (can_overwrite or !_has_motion_key(id, key)):
		_motions[id][key] = value

func _add_to_motion_key(id: int, key: String, value) -> void:
	if _has_motion_key(id, key):
		_motions[id][key] += value

func _remove_motion_from_id(id: String = "none", force: bool = false) -> bool:
	if !force and id == "none":
		return false
	var motion_id : int = 0
	var motion_size : int = _motions.size()
	while motion_id < motion_size:
		if id == _get_motion_key(motion_id, "id", "none"):
			_motions.pop_at(motion_id)
			motion_size -= 1
		else:
			motion_id += 1
	return true
