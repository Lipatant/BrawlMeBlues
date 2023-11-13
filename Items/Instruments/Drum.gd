extends Instrument
class_name Drum

func item_use_action() -> bool:
	update_equip_next()
	if !owner_entity:
		return false
	owner_entity.add_motion({"motion": Vector2(0, -25000), "duration": 0.3, "decreasing": true})
	_spawn_projectile(Vector2(1, 0), 200, 1)
	_spawn_projectile(Vector2(-1, 0), 200, 1)
	return true

func item_special() -> bool:
	update_equip_next()
	owner_entity.add_motion({"motion": Vector2(0, 35000), "duration": 0.5, "decreasing": true})
	_spawn_projectile(Vector2(1, 0), 400, 0)
	_spawn_projectile(Vector2(1, 0), 200, 1)
	_spawn_projectile(Vector2(-1, 0), 400, 0)
	_spawn_projectile(Vector2(-1, 0), 200, 1)
	return false
