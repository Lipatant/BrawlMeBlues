extends Instrument
class_name Clarinet

func item_use_action() -> bool:
	update_equip_next()
	if !owner_entity:
		return false
	owner_entity.add_motion({"motion": owner_entity.get_entity_rotation() * -20000, "duration": 0.5, "decreasing": true})
	_spawn_projectile(owner_entity.get_entity_rotation(), 300, 0)
	return true

func item_special() -> bool:
	update_equip_next()
	owner_entity.add_motion({"motion": owner_entity.get_entity_rotation() * -100000, "duration": 0.5, "decreasing": true})
	_spawn_projectile(owner_entity.get_entity_rotation(), 1000, 0)
	return false
