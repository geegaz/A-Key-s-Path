class_name RandomStreamPlayer, "./RandomStreamPlayer.svg"
extends AudioStreamPlayer

export(Array, AudioStream) var samples = []
export(float, 0, 2) var min_pitch: = 1.0
export(float, 0, 2) var max_pitch: = 1.0

func play_random(from_position: float = 0.0)->void:
	var samples_size = samples.size()
	if samples_size > 0:
		stream = samples[randi() % samples_size]
	pitch_scale = wrapf(randf()*2.0, min_pitch, max_pitch)
	play(from_position)

func get_class()->String:
	return "RandomStreamPlayer"
