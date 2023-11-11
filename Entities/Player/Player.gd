extends Entity
class_name Player

# EXPORTS #

@export var input_up    : String = "up"
@export var input_down  : String = "down"
@export var input_left  : String = "left"
@export var input_right : String = "right"
@export var input_jump  : String = "jump"

# ONREADIES #

@onready var wall_jump_movement_timer : Timer = $WallJumpMovement

# OTHER VARIABLES #

var wall_jump_movement : float = 0.0

# CONSTANTS #

const jump_particles_resource : Resource = preload("res://Entities/Entity/EntityJumpParticles.tscn")

# MOVEMENT #

func _entity_movement() -> Vector2:
	if _jumps > 0 and Input.is_action_just_pressed(input_jump):
		add_motion({"motion": Vector2(0, -jump_force), "duration": 0.5, "decreasing": true, "id": "jump"})
		_jumps -= 1
		if jump_particles_resource:
			var jump_particles : Node2D = jump_particles_resource.instantiate()
			if jump_particles:
				get_tree().current_scene.add_child(jump_particles)
				jump_particles.global_position = global_position
		if is_on_wall_only():
			wall_jump_movement = 1.2 if get_wall_normal().x > 0 else -1.2
			wall_jump_movement_timer.start()
	var local_movement : float = Input.get_action_strength(input_right) - Input.get_action_strength(input_left)
	if !wall_jump_movement_timer.is_stopped():
		local_movement *= 1 - (wall_jump_movement_timer.time_left / wall_jump_movement_timer.wait_time)
		local_movement += wall_jump_movement * (0.75 + (wall_jump_movement_timer.time_left / wall_jump_movement_timer.wait_time) / 4)
	if local_movement > 1.0:
		local_movement = 1.0
	elif local_movement < -1.0:
		local_movement = -1.0
	return Vector2(local_movement, 0.0)
