extends Node

var paused = false

enum {MASTER, SFX, MUSIC}
enum {UP, DOWN}

export(int) var current_level_id = 0
export(Array, String, FILE, "*.tscn") var levels = []
export(float, 0.0, 1.0) var sfx_volume
export(float, 0.0, 1.0) var music_volume

var Transitions: Array
var Player: AnimationPlayer

func _ready():
	$HUD/Pause.hide()
	Transitions = $TransitionLayer/Transitions.get_children()
	Player = $AnimationPlayer
	
	set_volume(SFX, 0.5)
	set_volume(MUSIC, 0.5)

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

func goto_level(id: int):
# warning-ignore:return_value_discarded
	transition(0, 0.5, DOWN, "hide")
	Player.connect("animation_finished", self, "finish_goto_level", [id])

func finish_goto_level(anim_name:String, id: int):
	if id == -1:
		get_tree().change_scene("res://Scenes/Main.tscn")
	elif id < levels.size():
		get_tree().change_scene(levels[id])
		current_level_id = id
	else:
		get_tree().change_scene(levels[-1])
	transition(0, 0.5, DOWN, "reveal")
	Player.disconnect("animation_finished", self, "finish_goto_level")
	
func transition(trans_id: int, time: float, direction: int, anim: String, flipped: bool = false):
	# Setup the transition node
	var transition
	for i in range(Transitions.size()):
		if i == trans_id:
			transition = Transitions[i]
			transition.show()
			transition.flip_v = flipped
		else:
			Transitions[i].hide()
	
	var Player = $AnimationPlayer
	Player.playback_speed = 1/time
	match direction:
		UP:
			Player.play(anim)
		DOWN:
			# If in the DOWN direction, need to invert the animations
			match anim:
				"reveal":
					Player.play_backwards("hide")
				"hide":
					Player.play_backwards("reveal")
	
	
func _on_Continue_pressed():
	paused = false
	$HUD/Pause.hide()
	Engine.time_scale = 1.0

func _on_BackToMenu_pressed():
	paused = false
	$HUD/Pause.hide()
	Engine.time_scale = 1.0
	goto_level(-1)
