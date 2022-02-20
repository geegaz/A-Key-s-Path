class_name RandomStreamPlayer, "./RandomStreamPlayer.svg"
extends AudioStreamPlayer

export(Array, AudioStream) var samples = []
# Pitch
export(float, 0, 2) var min_pitch: = 1.0
export(float, 0, 2) var max_pitch: = 1.0
# Volume
export(float, -80, 24) var min_volume: = 0.0
export(float, -80, 24) var max_volume: = 0.0

func play_random(from_position: float = 0.0)->void:
	var samples_size = samples.size()
	if samples_size > 0:
		stream = samples[randi() % samples_size]
	pitch_scale = wrapf(randf()*2.0, min_pitch, max_pitch)
	volume_db = wrapf(randf()*104 - 80, min_volume, max_volume)
	play(from_position)

func get_class()->String:
	return "RandomStreamPlayer"
