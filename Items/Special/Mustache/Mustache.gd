extends Item
class_name Mustache

# ONREADIES #

@onready var _timer : Timer = $Timer
@onready var _hitbox : CollisionShape2D = $Hitbox

# ITEM #

func unequip(_destroy: bool = false) -> void:
	super.unequip(false)
	_hitbox.disabled = true
	_timer.start()
	modulate = Color.WHITE * Color(1, 1, 1, 0.2)

func _on_timer_timeout():
	if _hitbox:
		_hitbox.disabled = false
		modulate = Color.WHITE
