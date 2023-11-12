extends Area2D
class_name Projectile

# ONREADIES #

@onready var _sprite : Sprite2D = $Sprite
@onready var _trail : CPUParticles2D = $Trail

# OTHER VARIABLES #

var owner_entity : Entity
var sprite_frame: int = 0
var velocity_vector : Vector2 = Vector2(0, 0)

# READY #

func _ready() -> void:
	if owner_entity and "player_id" in owner_entity:
		if _sprite:
			_sprite.set_modulate(BmbColor.from_player_id(owner_entity.player_id))
		if _trail:
			_trail.color = BmbColor.from_player_id(owner_entity.player_id)
	if _sprite:
		_sprite.frame = sprite_frame

# PROCESS #

func _physics_process(delta: float) -> void:
	position += velocity_vector * delta

# VELOCITY VECTOR #

func set_rotation_and_speed(new_rotation_vector: Vector2, new_speed: float) -> void:
	velocity_vector = new_rotation_vector.normalized() * new_speed

func set_velocity_vector(new_velocity_vector: Vector2 = Vector2(0, 0)) -> void:
	velocity_vector =  new_velocity_vector

# 

func destroy_projectile(_out_of_bound: bool = false):
	queue_free()

# SIGNALS #

func _on_area_exited(_area: Node2D) -> void:
	destroy_projectile(true)

func _on_body_entered(area: Node2D) -> void:
	if area is Entity:
		var entity : Entity = area
		if entity == owner_entity or !entity.is_hittable(owner_entity):
			return
		entity.hit(owner_entity)
