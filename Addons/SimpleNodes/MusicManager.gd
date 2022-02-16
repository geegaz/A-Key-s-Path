extends Node
class_name MusicManager

var queue: AudioStreamPlayer

onready var _Current: AudioStreamPlayer
onready var _Tween: Tween = Tween.new()

func _ready() -> void:
	add_child(_Tween)
	_Tween.connect("tween_completed",self,"_on_Tween_tween_completed")

func create_music(stream_path: String)->AudioStreamPlayer:
	var stream: AudioStream = load(stream_path)
	var new_player: = AudioStreamPlayer.new()
	new_player.stream = stream
	new_player.bus = "Music"
	return new_player

func change_music(new_music: AudioStreamPlayer, crossfade_time: float)->void:
	add_child(new_music)
	
	if crossfade_time > 0.0:
		_Tween.interpolate_property(
			new_music, "volume_db",
			new_music.volume_db, 0,
			crossfade_time
		)
		if _Current:
			_Tween.interpolate_property(
				_Current, "volume_db",
				_Current.volume_db, -80,
				crossfade_time
			)
	else:
		new_music.volume_db = 0
		if _Current:
			_Current.volume_db = -80
			_Current.queue_free()
	
	set_current(new_music)

func queue_music(new_queue: AudioStreamPlayer)->void:
	queue = new_queue
	add_child(queue)

func set_current(new_music: AudioStreamPlayer)->void:
	_Current = new_music
	_Current.connect("finished",self,"_on_Current_finished")
	_Current.play()

func _on_Current_finished()->void:
	if queue:
		_Current.queue_free()
		set_current(queue)
		
		queue = null

func _on_Tween_tween_completed(object: Object, key: String)->void:
	var value = object.get(key)
	if key == "volume_db" and value <= -80:
		object.queue_free()
