extends CPUParticles2D

@onready var timer = $Timer

func _ready() -> void:
	timer.wait_time = lifetime + 0.1
	timer.start()
	emitting = true

func _on_Timer_timeout() -> void:
	queue_free()
