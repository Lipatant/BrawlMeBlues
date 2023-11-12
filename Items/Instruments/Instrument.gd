extends Item
class_name Instrument

# ONREADIES #

@onready var _projectile_resource : Resource = preload("res://Projectiles/Projectile.tscn")
@onready var _use_cooldown : Timer = $UseCooldown

# ITEM ACTION #

func item_use() -> bool:
	if !_use_cooldown or !_use_cooldown.is_stopped():
		return false
	_use_cooldown.start()
	return item_use_action()

func item_use_action() -> bool:
	return false

# PROJECTILE #

func _spawn_projectile(projectile_rotation: Vector2, projectile_speed: float, sprite_frame: int = 0) -> Projectile:
	if !_projectile_resource or !owner_entity:
		return null
	var projectile : Projectile = _projectile_resource.instantiate()
	if projectile:
		projectile.global_position = global_position + projectile.position
#		projectile.global_position = owner_entity.global_position + projectile.position
		projectile.set_rotation_and_speed(projectile_rotation, projectile_speed)
		projectile.owner_entity = owner_entity
		projectile.sprite_frame = sprite_frame
		get_tree().current_scene.add_child(projectile)
	return projectile
