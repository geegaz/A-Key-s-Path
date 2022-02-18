extends CPUParticles2D

func _ready() -> void:
	one_shot = true
	emitting = true

func _process(_delta: float) -> void:
	if not emitting:
		queue_free()
