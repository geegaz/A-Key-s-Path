extends Sprite
class_name SpriteEffect

export var speed: float = 10
export var start_frame: int = 0
export var frames: int = 1
export var looping: bool = false

var time: float = 0

func _process(delta):
	time += delta
	var new_frame: int = (time * speed) + start_frame
	# Behavior: if looping, don't destroy at end
	if new_frame >= frames + start_frame:
		new_frame = start_frame
		if looping:
			time = 0
		else:
			queue_free()
	frame = new_frame
