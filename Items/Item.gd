extends Area2D
class_name Item

# OTHER VARIABLES #

var owner_entity : Entity
var _equip_next : Node
var _equip_next_keep : bool = false

const _item_drop_destroyed_resource : Resource = preload("res://Particles/ItemDropDestroyed.tscn")

# PROCESS #

func _physics_process(_delta: float) -> void:
	update_equip_next()

func update_equip_next() -> void:
	if !_equip_next:
		return
	var new_global_position : Vector2 = global_position
	get_parent().remove_child(self)
	_equip_next.add_child(self)
	_equip_next = null
	if _equip_next_keep:
		global_position = new_global_position
		_equip_next_keep = false

# ITEM ACTION #

func item_use() -> bool:
	return false

func item_special() -> bool:
	return false

# ITEM #

func equip_at_node(node: Node2D = null) -> void:
	if node:
		_equip_next = node

func equip_to(entity: Entity = null) -> void:
	if !entity:
		owner_entity = null
	else:
		if owner_entity:
			owner_entity.unequip()
		entity.equip(self)
		owner_entity = entity

func unequip(destroy: bool = false) -> void:
	if owner_entity:
		owner_entity.held_item = null
	if destroy:
		item_destroy()
	else:
		_equip_next = get_tree().current_scene
		_equip_next_keep = true
		owner_entity = null

func item_destroy() -> void:
	owner_entity = null
	generate_particles(_item_drop_destroyed_resource)
	queue_free()

# OTHERS #

func generate_particles(resource: Resource) -> Node2D:
	if !resource:
		return null
	var particles : Node2D = resource.instantiate()
	if particles:
		get_tree().current_scene.add_child(particles)
		particles.global_position = global_position + particles.position
	return particles

# SIGNALS #

func _on_body_entered(entity: Entity) -> void:
	if !owner_entity and entity and !entity.held_item and entity.can_grab_item(self):
		equip_to(entity)
