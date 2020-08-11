extends Node

signal change_scene_ready

var paused = false

enum {MASTER, SFX, MUSIC}

export(int) var max_unlocked_level = 0
export(float, 0.0, 1.0) var sfx_volume
export(float, 0.0, 1.0) var music_volume

onready var TransitionPlayer: AnimationPlayer = $TransitionLayer/TransitionPlayer
onready var Transitions: Array = $TransitionLayer/Transitions.get_children()
var current_transition = "down"

func _ready():
	$HUD/Pause.hide()
	
	set_volume(SFX, 0.5)
	set_volume(MUSIC, 0.5)
	set_transition()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit"):
		var scene_name = get_tree().current_scene.name
		if scene_name == "Main":
			get_tree().quit()
		else:
			paused = !paused
			if paused:
				$HUD/Pause.show()
				Engine.time_scale = 0.0
			else:
				$HUD/Pause.hide()
				Engine.time_scale = 1.0

func set_volume(bus: int, volume_scale: float):
	var volume = -72.0 + (volume_scale*72.0)
	match bus:
		SFX:
			sfx_volume = volume_scale
			AudioServer.set_bus_volume_db(SFX, volume)
		MUSIC:
			music_volume = volume_scale
			AudioServer.set_bus_volume_db(MUSIC, volume)

func set_transition(id: int = 0, time: float = 1.0, direction: String = "down"):
	for i in range(Transitions.size()):
		if i == id:
			Transitions[i].show()
		else:
			Transitions[i].hide()
	
	if time != 0.0:
		TransitionPlayer.playback_speed = 1/time
	
	match direction:
		"left","right","up","down":
			current_transition = direction
		_:
			current_transition = "down"
		

func goto_scene(path: String = ""):
# warning-ignore:return_value_discarded
	
	TransitionPlayer.play(current_transition)
	yield(self, "change_scene_ready")
	match path:
		"menu","":
			get_tree().change_scene("res://Scenes/Main.tscn")
		_:
			get_tree().change_scene(path)
	
func _on_Continue_pressed():
	paused = false
	$HUD/Pause.hide()
	Engine.time_scale = 1.0

func _on_BackToMenu_pressed():
	paused = false
	$HUD/Pause.hide()
	Engine.time_scale = 1.0
	
	set_transition()
	goto_scene("menu")
