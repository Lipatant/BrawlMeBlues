extends Instrument
class_name Microphone

func item_use_action() -> bool:
	update_equip_next()
	if !owner_entity:
		return false
	var rotation_angle : float = owner_entity.get_entity_rotation().angle()
	owner_entity.add_motion({"motion": owner_entity.get_entity_rotation() * -20000, "duration": 0.5, "decreasing": true})
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle - 0.349066), 200, 1)
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle), 200, 1)
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle + 0.349066), 200, 1)
	return true

func item_special() -> bool:
	update_equip_next()
	var rotation_angle : float = owner_entity.get_entity_rotation().angle()
	owner_entity.add_motion({"motion": owner_entity.get_entity_rotation() * -40000, "duration": 0.5, "decreasing": true})
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle - 1.0472), 100, 2)
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle - 0.523599), 150, 1)
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle), 200, 0)
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle + 0.523599), 150, 1)
	_spawn_projectile(Vector2(1,0).rotated(rotation_angle + 1.0472), 100, 2)
	return false
