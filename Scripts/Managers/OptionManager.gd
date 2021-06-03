extends Node

# Sounds
var volumes: Array = [0.7, 0.7, 0.7] setget set_volumes
enum {MASTER, SFX, MUSIC}

# Video
var fullscreen: bool = false setget set_fullscreen
var screenshake: bool = true setget set_screenshake

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_volume_linear(bus: int)->float:
	return db2linear(AudioServer.get_bus_volume_db(bus))

func set_volume_linear(bus: int, volume_scale: float):
	var volume = linear2db(volume_scale)
	AudioServer.set_bus_volume_db(bus, volume)

func set_volumes(new_volumes: Array):
	volumes = new_volumes
	for i in volumes.size():
		set_volume_linear(i, volumes[i])

func set_fullscreen(state: bool):
	OS.window_fullscreen = state
	fullscreen = state

func set_screenshake(state: bool):
	screenshake = state


func to_dict()->Dictionary:
	var dict = {}
	return dict
