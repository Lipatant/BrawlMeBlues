extends CharacterBody2D
class_name Entity

# EXPORTS #

@export var speed : float = 10000.0
@export var jump_force : float = 50000.0
@export var jump_count : int = 2

# ONREADIES #

@onready var _wall_jump_movement_timer : Timer = $WallJumpMovement

# OTHER VARIABLES #

var _motions : Array[Dictionary] = []
var _jumps : int = 0
var _since_floor : float = 0.0

var _wall_jump_movement : float = 0.0

# CONSTS #

const BASE_GRAVITY : float = 16000.0

const jump_particles_resource : Resource = preload("res://Particles/EntityJumpParticles.tscn")
const ceiling_particles_resource : Resource = preload("res://Particles/EntityCeilingParticles.tscn")

# PROCESS #

func _physics_process(delta: float) -> void:
	velocity.x = 0
	# Gravity
	if _since_floor >= 1.0:
		velocity.y = _get_gravity_force()
	elif _since_floor > 0.0:
		velocity.y = _get_gravity_force() * (0.5 + _since_floor / 2)
	if is_wall_sliding():
		_remove_motion_from_id("jump")
		velocity.y /= 5
	# Entity Movement
	var entity_moment : Vector2 = _entity_movement()
	if !_wall_jump_movement_timer.is_stopped():
		entity_moment.x *= 1 - (_wall_jump_movement_timer.time_left / _wall_jump_movement_timer.wait_time)
		entity_moment.x += _wall_jump_movement * (0.75 + (_wall_jump_movement_timer.time_left / _wall_jump_movement_timer.wait_time) / 4)
	if entity_moment.x > 1.0:
		entity_moment.x = 1.0
	elif entity_moment.x < -1.0:
		entity_moment.x = -1.0
	velocity += entity_moment * speed
	#
	velocity += _process_motion(delta)
	velocity *= delta
	move_and_slide()
	if is_on_ceiling():
		if _remove_motion_from_id("jump"):
			generate_particles(ceiling_particles_resource)
	if is_on_floor():
		_since_floor = 0
		_jumps = jump_count
	else:
		_since_floor += delta
	if is_wall_sliding():
#		_jumps = 1 if jump_count >= 1 else jump_count
		_jumps = jump_count
		if _since_floor > 0.2:
			_since_floor = 0.2

func _entity_movement() -> Vector2:
	return Vector2(0, 0)

func is_wall_sliding(only: bool = false) -> bool:
	return is_on_wall_only() if only else is_on_wall()

# JUMP #

func _entity_jump(force: bool = false) -> void:
	if force or _jumps > 0:
		if !force:
			_jumps -= 1
		add_motion({"motion": Vector2(0, -jump_force), "duration": 0.5, "decreasing": true, "id": "jump"})
		generate_particles(jump_particles_resource)
		if is_wall_sliding(true):
			_wall_jump_movement = 1.2 if get_wall_normal().x > 0 else -1.2
			_wall_jump_movement_timer.start()

# GET CONSTANTS #

func _get_gravity_force() -> float:
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

# PARTICLES

func generate_particles(resource: Resource) -> Node2D:
	if !resource:
		return null
	var particles : Node2D = resource.instantiate()
	if particles:
		get_tree().current_scene.add_child(particles)
		particles.global_position = global_position + particles.position
	return particles
