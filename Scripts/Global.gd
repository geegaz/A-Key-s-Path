extends Node

var paused = false
var Player: AnimationPlayer
var tuto_state = 0

enum {MASTER, SFX, MUSIC}
var sfx_volume = 0.5
var music_volume = 0.5

func _ready():
	$HUD/Pause.hide()
	Player = $HUD/AnimationPlayer
	Player.playback_speed = 3.0
	
	set_volume(SFX, 0.5)
	set_volume(MUSIC, 0.5)

func _input(event):
	if event.is_action_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit"):
		var scene_name = get_tree().current_scene.name
		print(scene_name)
		if scene_name == "World":
			paused = !paused
			if paused:
				$HUD/Pause.show()
				Engine.time_scale = 0.0
			else:
				$HUD/Pause.hide()
				Engine.time_scale = 1.0
		elif scene_name == "Main":
			get_tree().quit()

func set_volume(bus: int, volume_scale: float):
	var volume = -72 + (volume_scale*72.0)
	match bus:
		SFX:
			sfx_volume = volume_scale
			AudioServer.set_bus_volume_db(SFX, volume)
		MUSIC:
			music_volume = volume_scale
			AudioServer.set_bus_volume_db(MUSIC, volume)
	

func goto_scene(path: String):
# warning-ignore:return_value_discarded
	Player.connect("animation_finished", self, "finish_goto_scene", [path])
	Player.play("transition_hide")
	
func finish_goto_scene(_anim, path: String):
# warning-ignore:return_value_discarded
	get_tree().change_scene(path)
	Player.disconnect("animation_finished", self, "finish_goto_scene")
	Player.play("transition_reveal")
	
func _on_Continue_pressed():
	paused = false
	$HUD/Pause.hide()
	Engine.time_scale = 1.0

func _on_BackToMenu_pressed():
	paused = false
	$HUD/Pause.hide()
	Engine.time_scale = 1.0
	goto_scene("res://Scenes/Main.tscn")
