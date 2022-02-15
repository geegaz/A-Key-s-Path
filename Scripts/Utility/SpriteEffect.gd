extends Sprite

export var speed: float = 10
export var frames: int = 1
export var looping: bool = false

var time: float = 0

func _process(delta):
	time += delta
	var new_frame: int = time * speed
	# Behavior: if looping, don't destroy at end
	if new_frame >= frames:
		new_frame = 0
		if looping:
			time = 0
		else:
			queue_free()
	frame = new_frame
