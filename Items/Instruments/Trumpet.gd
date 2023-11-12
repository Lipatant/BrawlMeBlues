extends Instrument
class_name Trumpet

func item_use_action() -> bool:
	update_equip_next()
	if !owner_entity:
		return false
	owner_entity.add_motion({"motion": owner_entity.get_entity_rotation() * -10000, "duration": 0.5, "decreasing": true})
	_spawn_projectile(owner_entity.get_entity_rotation(), 200, 1)
	return true

func item_special() -> bool:
	update_equip_next()
	for x in [-1, 0, 1]:
		for y in [-1, 0, 1]:
			if x == 0 and y == 0:
				continue
			_spawn_projectile(Vector2(x,y), 100, 2)
	return false
