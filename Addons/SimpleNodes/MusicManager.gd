extends Node
class_name MusicManager

onready var musics: = {}

var current_music: = ""
var queue: = ""

onready var _Tracks: = [
	AudioStreamPlayer.new(),
	AudioStreamPlayer.new()
]

onready var _Tween: Tween = Tween.new()

func _ready() -> void:
	add_child(_Tween)
	_Tween.connect("tween_completed",self,"_on_Tween_tween_completed")
	for track in _Tracks:
		add_child(track)
		track.bus = "Music"
		track.connect("finished",self,"_on_Track_finished", [track])

func change_music(new_music: String, crossfade_time: float = 0.0)->void:
	if new_music == current_music:
		return
	elif new_music in musics:
		_Tracks[-1].stream = musics[new_music]
	else:
		_Tracks[-1].stream = null
	
	_Tracks[-1].play()
	if crossfade_time > 0.0:
		_Tween.remove_all()
		_Tween.interpolate_property(
			_Tracks[-1], "volume_db",
			_Tracks[-1].volume_db, 0,
			crossfade_time, 
			Tween.TRANS_CUBIC, Tween.EASE_IN
		)
		_Tween.interpolate_property(
			_Tracks[0], "volume_db",
			_Tracks[0].volume_db, -80,
			crossfade_time, 
			Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		_Tween.start()
	else:
		_Tracks[-1].volume_db = 0
		_Tracks[0].volume_db = -80
		_Tracks[0].stop()
	
	queue = ""
	current_music = new_music
	_Tracks.invert()

func stop_music(stop_time: float = 0.0)->void:
	queue = ""
	change_music("", stop_time)

func queue_music(new_music: String)->void:
	queue = new_music

func _on_Track_finished(track: Node)->void:
	if _Tracks.find(track) == 0 and queue in musics:
		change_music(queue)

func _on_Tween_tween_completed(object: Object, key: String)->void:
	var value = object.get(key)
	if key == "volume_db" and value <= -80:
		# Then it's probably one of the tracks
		object.stop()
